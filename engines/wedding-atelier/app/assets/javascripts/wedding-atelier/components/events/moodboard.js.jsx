var MoodBoardEvent = React.createClass({

  propTypes: {
    bot_profile_photo: React.PropTypes.string,
    channel_prefix: React.PropTypes.string,
    current_user_id: React.PropTypes.number,
    current_user: React.PropTypes.object,
    dress: React.PropTypes.object,
    dresses_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    event_path: React.PropTypes.string,
    filestack_key: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
    roles_path: React.PropTypes.string,
    send_invite_path: React.PropTypes.string,
    siteVersion: React.PropTypes.string,
    sizing_path: React.PropTypes.string,
    twilio_token_path: React.PropTypes.string,
    user_id: React.PropTypes.number,
    username: React.PropTypes.string,
    wedding_name: React.PropTypes.string
  },

  getInitialState: function () {
    return {
      twilioManager: null,
      twilioClient: null,
      sizes: [],
      heights: [],
      chat: {
        members: [],
        messages: [],
        typing: []
      },
      event: {
        dresses: [],
        invitations: [],
        assistants: [],
        send_invite_path: '',
        current_user_id: -1,
        owner_id: -1,
        name: '',
        hasError: {}
      },
      event_backup: {
        dresses: [],
        invitations: [],
        assistants: [],
        send_invite_path: '',
        current_user_id: -1,
        owner_id: -1,
        name: '',
        hasError: {}
      },
      dressToAddToCart: null,
      userCart: null
    };
  },

  componentWillMount: function(){
    this.setUpData();
    this.setDefaultTabWhenResize();
  },

  setUpData: function(){
    var that = this;
    var eventPromise = $.getJSON(that.props.event_path + '.json');
    var sizingPromise = $.getJSON(this.props.sizing_path + '.json');

    Promise.all([eventPromise, sizingPromise]).then(function(values){
      var event = values[0].moodboard_event,
          sizes = values[1].sizing.sizes,
          heights = values[1].sizing.heights;

      var _state = $.extend({}, that.state);
      _state.event = event;
      _state.event_backup = event;
      _state.sizes = sizes;
      _state.heights = heights;
      that.setState(_state);
      that.loadChatToken();
    });
  },

  loadChatToken: function() {
    that = this;
    $.post(this.props.twilio_token_path + '.json', function(response){
      var token = response.token,
          twilioManager = new Twilio.AccessManager(token);
      var _state = $.extend({}, that.state);
      _state.twilioManager = twilioManager;
      _state.twilioClient = new Twilio.IPMessaging.Client(twilioManager);
      that.setState(_state);
      that.setupChatChannels();
    }).fail(function(e) {
      ReactDOM.render(<Notification errors={["Sorry, there was a problem starting your chat session. We'll have it back up and running soon."]} />,
          document.getElementById('notification'));
    });
  },

  setupChatChannels: function(){
    var _state = $.extend({}, this.state);
    var that = this;
    var channelName = this.props.channel_prefix + 'wedding-atelier-channel-' + this.props.event_id;
    var notificationsChannelName = this.props.channel_prefix + '-wedding-atelier-notifications-' + this.props.event_id;

    // notifications channel
    _state.twilioClient.getChannelByUniqueName(notificationsChannelName).then(function(channelNotifications) {
      if (channelNotifications) {
        that.setState({channelNotifications: channelNotifications});
        that.setupNotificationsChannel();
      } else {
        _state.twilioClient.createChannel({
          uniqueName: notificationsChannelName,
          friendlyName: 'Notifications for: ' + that.props.wedding_name
        }).then(function(channelNotifications) {
            that.setState({channelNotifications: channelNotifications});
            that.setupNotificationsChannel();
        });
      }
    });

    // normal messaging client
    _state.twilioClient.getChannelByUniqueName(channelName).then(function(chatChannel) {
      if (chatChannel) {
        that.setState({chatChannel: chatChannel});
        chatChannel.join().then(function() {
          console.log('Joined channel as ' + that.props.username);
          that.setUpMessagingEvents();
          that.loadChannelHistory();
          that.loadChannelMembers();
        });
      } else {
        _state.twilioClient.createChannel({
          uniqueName: channelName,
          friendlyName: that.props.wedding_name
        }).then(function(chatChannel) {
          that.setState({chatChannel: chatChannel});
          chatChannel.join().then(function() {
            that.setUpMessagingEvents();
            //It needs a bit time to setup event listeners properly
            setTimeout(function() {
              // TODO: After refactor remove this setTimeout...
              that.sendMessageBot("Welcome to your wedding board! Here's where you can chat with me (the BridalBot), your wedding party, and your Fame stylist to create your custom wedding looks.").then(function() {
                return that.sendMessageBot("Why don't you begin by creating your first dress?" + '(Just click "ADD YOUR FIRST DRESS" over to the right.) Or, invite a stylist to join your chat to help you get started.');
              });
            }, 3000);
          });
        });
      }
    });
  },

  startTyping: function() {
    this.state.chatChannel.typing();
  },

  setTypingIndicator: function(member, typing){
    var _whoIsTyping = [...this.state.chat.typing];
    var _isAlreadyTyping = whoIsTyping.indexOf(member.identity) > -1;

    if (typing && !_isAlreadyTyping) {
      _whoIsTyping.push(member.identity);
    } else {
      var index = _whoIsTyping.indexOf(member.identity);
      _whoIsTyping.splice(index, 1);
    }

    var _chat = $.extend({}, this.state.chat);
    _chat.typing = _whoIsTyping;
    this.setState({chat: _chat});
  },

  sendMessageBot: function(message, type) {
    if (type === undefined) {
      type = "simple";
    }

    message = {
      profilePhoto: this.props.bot_profile_photo,
      author: "BridalBot",
      time: Date.now(),
      type: type,
      content: message
    };

    return this.sendMessageToTwillio(message);
  },

  sendMessageToTwillio: function(message) {
    return this.state.chatChannel.sendMessage(JSON.stringify(message));
  },

  sendNotificationToTwillio: function(message) {
    return this.state.channelNotifications.sendMessage(JSON.stringify(message));
  },

  loadChannelMembers: function() {
    var that = this;
    this.state.chatChannel.getMembers().then(function(members) {
      var chatMembers = members.map(function(member) {
        var nameInitials = member.identity.match(/\b\w/g).join("").toUpperCase();

        return {
          id: member.sid,
          identity: member.identity,
          initials: nameInitials,
          online: true
        };
      });

      var _state = $.extend({}, that.state);
      _state.chat.members = chatMembers.slice(1);
      that.setState(_state);
    });
  },

  setupNotificationsChannel: function() {
    var that = this;

    this.state.channelNotifications.join().then(function(channel) {
      console.log('Joined notifications channel as ' + that.props.username);
    });

    // Listening for notifications...
    this.state.channelNotifications.on('messageAdded', function (message) {
      var parsedMsg = JSON.parse(message.body);

      // Notification dress-like: A like to a dress was given by someone.
      if (parsedMsg.type === "dress-like") {
        var dresses = [...that.state.event.dresses];

        var index = dresses.findIndex(function(dress) {
          return dress.id === parsedMsg.dress.id;
        });

        dresses[index].likes_count = parsedMsg.dress.likes_count;

        var _event = $.extend({}, that.state.event);
        _event.dresses = dresses;
        that.setState({event: _event});
      }
    });
  },

  loadChannelHistory: function() {
    this.state.chatChannel.getMessages(20).then(function(messages) {
      var _messages = messages.map(function(message) {
        return JSON.parse(message.body)
      });

      var _chat = $.extend({}, this.state.chat);
      _chat.messages = _messages;
      this.setState({chat: _chat});
    }.bind(this));
  },

  handleMember: function(member, joined) {
    if (joined) {
      var newMember = {
        id: member.sid,
        identity: member.identity,
        initials: member.identity.match(/\b\w/g).join("").toUpperCase(),
        online: joined
      };

      var _newState = $.extend({}, this.state);
      _newState.channelMembers.push(_newUser);
      this.setState(_newState);
    } else {
      // TODO: handle remove
    }
  },

  setUpMessagingEvents: function() {
    var that = this;

    this.state.chatChannel.on('messageAdded', function (message) {
      var _messages = [...that.state.chat.messages];
      var parsedMsg = JSON.parse(message.body);

      _messages.push(parsedMsg);

      var _chat = $.extend({}, that.state.chat);
      _chat.messages = _messages;
      that.setState({chat: _chat});
    });

    this.state.chatChannel.on('memberJoined', function(member) {
      that.handleMember(member, true);
    });

    this.state.chatChannel.on('memberLeft', function(member) {
      // TODO: make sure this works.
      that.handleMember(member, false);
    });

    this.state.chatChannel.on('typingStarted', function(member){
      // TODO: Set typing indicator.
      that.setTypingIndicator(member, true);
    });

    this.state.chatChannel.on('typingEnded', function(member){
      that.setTypingIndicator(member, false);
    });
  },

  removeDress: function(dress){
    var that = this,
        dressId = dress.id,
        url = this.props.dresses_path + '/' + dressId;
    $.ajax({
      url: url,
      type: 'DELETE',
      dataType: 'json',
      success: function(data) {
        var _newState = $.extend({}, that.state);
        _newState.event.dresses = _.reject(_newState.event.dresses, function(eventDress){
          return eventDress.id === dressId;
        });
        that.setState(_newState);
      }.bind(this),
      error: function(error) {
        ReactDOM.render(<Notification errors={[error.statusText]} />,
                    $('#notification')[0]);
      }
    });
  },

  handleLikeDress: function(dress) {
    var that = this,
        _event = $.extend({}, that.state.event),
        method = dress.liked ? 'DELETE' : 'POST',
        url = this.props.event_path + '/dresses/' + dress.id + '/likes',
        dress = _.findWhere(_event.dresses, {id: dress.id});

    $.ajax({
      url: url,
      method: method,
      dataType: 'json',
      success: function(data){
        if(method === 'POST'){
          dress.likes_count++;
          dress.liked = true;
        }else{
          dress.likes_count--;
          dress.liked = false;
        }

        that.sendNotificationToTwillio({
          type: 'dress-like',
          dress: dress
        });

        that.setState({event: _event});
      },
      error: function(data){
        // TODO add notification after is merged.
      }
    });
  },

  eventDetailsUpdated: function (collection) {
    this.setState({event: collection.moodboard_event});
    var event = $.extend(event, this.state.event);
    event.hasError = {};
    this.setState({
      event: event,
      event_backup: event
    });
  },

  eventDetailsUpdateFailed: function (data) {
    var parsed = JSON.parse(data.responseText);
    var newEventState = $.extend(event, this.state.event_backup);
    var hasError = {};

    for(var key in parsed.errors) {
      hasError[key] = true;
      newEventState[key] = this.state.event_backup[key];
    }

    newEventState.hasError = hasError;
    this.setState({event: event});
  },

  handleRemoveAssistant: function(id, index){
    $.ajax({
      url: this.props.remove_assistant_path.replace(':id', id),
      type: 'DELETE',
      dataType: 'json',
      success: function(_data) {
        var event = this.state.event;
        event.assistants.splice(index, 1);
        this.setState({event: event});
      }.bind(this),
      error: function(_data) {
        var errors = JSON.parse(_data.responseText).errors
        ReactDOM.render(<Notification errors={[errors[0]]} />,
                    $('#notification')[0]);
      }
    });
  },

  sendMessageTile: function(dress) {
    return this.sendMessage(dress, "dress");
  },

  sendMessage: function (message, type){
    if (type === undefined) {
      type = "simple";
    }

    message = {
      profilePhoto: this.props.profile_photo,
      author: this.props.username,
      user_id: this.props.user_id,
      time: Date.now(),
      type: type,
      content: message
    };

    return this.sendMessageToTwillio(message);
  },

  setDefaultTabWhenResize: function(){
    $(window).resize(function(e) {
      if (e.target.innerWidth >= 768 ) {
        var activeMobileChat = $(this.refs.ChatComp).hasClass('active');
        if(activeMobileChat){
          $('.moodboard-tabs a[href="#bridesmaid-dresses"]').tab('show');
        }
      }
    }.bind(this));
  },

  changeDressToAddToCartCallback: function(dress){
    var _state = $.extend({}, this.state);
    _state.dressToAddToCart = dress;
    this.setState(_state);
  },

  updateUserCartCallback: function(cart) {
    var _state = $.extend({}, this.state);
    _state.userCart = cart;
    this.setState(_state);
  },

  render: function () {
    var chatProps = {
      bot_profile_photo: this.props.bot_profile_photo,
      profile_photo: this.props.profile_photo,
      username: this.props.username,
      user_id: this.props.user_id,
      filestack_key: this.props.filestack_key,
      handleLikeDress: this.handleLikeDress,
      changeDressToAddToCartCallback: this.changeDressToAddToCartCallback,
      startTypingFn: this.startTyping,
      sendMessageFn: this.sendMessage,
      messages: this.state.chat.messages,
      members: this.state.chat.members,
      typing: this.state.chat.typing,
      dresses: this.state.event.dresses
    };

    var selectSizeProps = {
      dress: this.props.dress,
      current_user_id: this.props.current_user_id,
      profiles: this.state.event.assistants,
      sizes: this.state.sizes,
      heights: this.state.heights,
      siteVersion: this.props.siteVersion,
      dressToAddToCart: this.state.dressToAddToCart,
      updateUserCartCallback: this.updateUserCartCallback
    };

    var addNewDressBigButton = '';
    var addNewDressSmallButton = '';

    if (this.state.event.dresses && this.state.event.dresses.length === 0) {
      addNewDressBigButton = <div className="add-dress-box"><a href={this.props.event_path + '/dresses/new'} className="add">Design a new dress</a></div>
    } else if (this.state.event.dresses && this.state.event.dresses.length > 0 ) {
      addNewDressSmallButton = <div className="dresses-actions text-center"><a href={this.props.event_path + '/dresses/new'} className="btn-transparent btn-create-a-dress"><em>Design</em> a new dress</a></div>;
    }

    return (
      <div id="events__moodboard" className="row">
        <SelectSizeModal {...selectSizeProps}/>
        <SizeGuideModal />
        <div className="left-content col-sm-5 hidden-xs">
          <Chat ref="ChatComp" {...chatProps}/>
        </div>
        <div className="right-content col-sm-7">
          <div className="right-container center-block">
            <h1 className="moodboard-title text-center">
               The Countdown: {this.state.event.remaining_days} days
            </h1>

            <div className="moodboard-tabs center-block">
              <div className="tabs-container">
                <ul className="nav nav-tabs center-block" role="tablist">
                  <li role="presentation" className="tab-chat hidden">
                    <a aria-controls="chat-mobile" data-toggle="tab" href="#chat-mobile" role="tab">
                      Chat</a>
                  </li>
                  <li
                    className="active walkthrough-messages"
                    role="presentation"
                    title="View your dresses"
                    data-content="Create new looks and vote on your favorites"
                    data-placement="bottom">
                    <a aria-controls="bridesmaid-dresses" data-toggle="tab" href="#bridesmaid-dresses" role="tab">
                      Bridesmaid dresses</a>
                  </li>
                  <li
                    role="presentation"
                    className="walkthrough-messages"
                    title="Update the details"
                    data-content="Input everything you need to know about the big day"
                    data-placement="top">
                    <a aria-controls="wedding-details" data-toggle="tab" href="#wedding-details" role="tab">
                    Wedding details</a>
                  </li>
                  <li
                    role="presentation"
                    className="walkthrough-messages"
                    title="Manage the group"
                    data-content="Add, view, and remove members of the bridal party"
                    data-placement="bottom">
                    <a aria-controls="manage-bridal-party" data-toggle="tab" href="#manage-bridal-party" role="tab">Bridal party</a>
                  </li>
                  <li role="presentation" className="bridal-gowns">
                    <a aria-controls="bridal-gowns" href="#bridal-gowns" role="tab">
                      <span className="coming-soon">Coming Soon</span>
                      <span>Bridal Gowns</span>
                    </a>
                  </li>
                </ul>
              </div>
              <div className="tab-content">
                <div id="chat-mobile" className="tab-pane col-xs-12" ref="chatMobile" role="tabpanel">
                  <Chat {...chatProps}/>
                </div>
                <div id="bridesmaid-dresses" className="tab-pane active center-block" role="tabpanel">
                  {addNewDressBigButton}
                  {addNewDressSmallButton}
                  <div className="dresses-list center-block">
                    <DressTiles dresses={this.state.event.dresses}
                      sendDressToChatFn={this.sendMessageTile}
                      removeDress={this.removeDress}
                      dressesPath={this.props.dresses_path}
                      handleLikeDress={this.handleLikeDress}
                      changeDressToAddToCartCallback={this.changeDressToAddToCartCallback}/>
                  </div>
                </div>
                <div id="wedding-details" className="tab-pane" role="tabpanel">
                  <EventDetails event={this.state.event}
                                current_user={this.props.current_user.user}
                                eventDetailsUpdated={this.eventDetailsUpdated}
                                eventDetailsUpdateFailed={this.eventDetailsUpdateFailed}
                                eventDetailsUpdatePath={this.props.event_path}
                                hasError={this.state.event.hasError}
                                roles_path={this.props.roles_path} />
                </div>
                <div id="manage-bridal-party" className="tab-pane center-block" role="tabpanel">
                  <h1 className="text-center">
                    <em>Now</em>, let's invite the bridal party.
                  </h1>
                  <EventInvitations
                    initialInvitations={this.state.event.invitations}
                    assistants={this.state.event.assistants}
                    event_owner_id={this.state.event.owner_id}
                    handleRemoveAssistant={this.handleRemoveAssistant}
                    send_invite_path={this.props.send_invite_path}
                    current_user_id={this.props.current_user_id}
                  />
                </div>
                <div id="bridal-gowns" className="tab-pane" role="tabpanel">

                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
