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

  twilioCodes: {
    CHANNEL_NOT_FOUND: 50300
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
        typing: [],
        unreadCount: 0
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
    var that = this;
    $.post(this.props.twilio_token_path + '.json', function(response){
      var token = response.token,
          twilioClient = new Twilio.Chat.Client(token);
      var _state = $.extend({}, that.state);
      _state.twilioClient = twilioClient;
      that.setState(_state);
      twilioClient.initialize().then(function(){
        that.setupChatChannel();
        that.setupNotificationsChannel();
      });
    }).fail(function(e) {
      ReactDOM.render(<Notification errors={['Sorry, there was a problem starting your chat session. We\'ll have it back up and running soon.']} />,
          document.getElementById('notification'));
    });
  },

  setupChatChannel: function(){
    var that = this;
    var chatChannelName = this.props.channel_prefix + 'wedding-atelier-channel-' + this.props.event_id;
    this.state.twilioClient.getChannelByUniqueName(chatChannelName).then(function(channel){
      channel.join().then(function() {
        console.log('Joined channel as ' + that.props.username);
        that.setState({chatChannel: channel});
        that.setUpMessagingEvents();
        that.loadChannelHistory();
        that.loadChannelMembers();
      });

    }, function(e){
      if(e.body.code == that.twilioCodes.CHANNEL_NOT_FOUND){
        that.state.twilioClient.createChannel({
          uniqueName: chatChannelName,
          friendlyName: that.props.wedding_name
        }).then(function(chatChannel) {
          chatChannel.join().then(function() {
            that.setState({chatChannel: chatChannel});
            that.setUpMessagingEvents();
            that.sendMessageBot('Welcome to your wedding board. Here\'s where you can chat with your bridal party, discuss different wedding looks and invite a Fame stylist.').then(function(){
              that.sendMessageBot('Why don\'t you begin by creating your first dress? Just select \'ADD YOUR FIRST DRESS\' to start customizing.');
            });
          });
        });
      }
    });
  },

  setupNotificationsChannel: function(){
    var that = this;
    var notificationsChannelName = this.props.channel_prefix + '-wedding-atelier-notifications-' + this.props.event_id;
    this.state.twilioClient.getChannelByUniqueName(notificationsChannelName).then(function(channelNotifications){
      that.setState({channelNotifications: channelNotifications});
      that.state.channelNotifications.join().then(function(channel) {
        console.log('Joined notifications channel as ' + that.props.username);
        that.setUpNotificationListeners();
      });
    }, function(e){
      that.state.twilioClient.createChannel({
        uniqueName: notificationsChannelName,
        friendlyName: 'Notifications for: ' + that.props.wedding_name
      }).then(function(channelNotifications) {
        that.setState({channelNotifications: channelNotifications});
        that.state.channelNotifications.join().then(function(channel) {
          console.log('Joined notifications channel as ' + that.props.username);
          that.setUpNotificationListeners();
        });
      });
    })
  },

  startTyping: function() {
    this.state.chatChannel.typing();
  },

  setTypingIndicator: function(member, typing){
    var _whoIsTyping = [...this.state.chat.typing];
    var _isAlreadyTyping = _whoIsTyping.indexOf(member.identity) > -1;

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

  setUpNotificationListeners: function() {
    var that = this;
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
      var _messages = messages.items.map(function(message) {
        return JSON.parse(message.body);
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
      _newState.channelMembers.push(newMember);
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
      if(!$('.tab-chat').hasClass('active')) {
        _chat.unreadCount++;
      }
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
    var _newEvent = $.extend({}, this.state.event);
    event.hasError = {};
    this.setState({
      event: _newEvent,
      event_backup: _newEvent
    });
  },

  eventDetailsUpdateFailed: function (data) {
    var parsed = JSON.parse(data.responseText);
    var _newEvent = $.extend({}, this.state.event_backup);
    var hasError = {};

    for(var key in parsed.errors) {
      hasError[key] = true;
      _newEvent[key] = this.state.event_backup[key];
    }

    _newEvent.hasError = hasError;
    this.setState({event: _newEvent});
  },

  handleRemoveAssistant: function(id, index){
    $.ajax({
      url: this.props.remove_assistant_path.replace(':id', id),
      type: 'DELETE',
      dataType: 'json',
      success: function(_data) {
        var _newEvent = $.extend({}, this.state.event);
        _newEvent.assistants.splice(index, 1);
        this.setState({event: _newEvent});
        var errors = ['Board member removed.'];
        ReactDOM.render(<Notification errors={errors} />,
                    $('#notification')[0]);
      }.bind(this),
      error: function(_data) {
        var errors;
        try{
          errors = JSON.parse(_data.responseText).errors;
        }catch(e){
          errors = ["We're sorry something went wrong."];
        }
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

  resetUnreadCount: function(){
    var _chat = $.extend({}, this.state.chat);
    _chat.unreadCount = 0;
    this.setState({chat: _chat});
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

    var addNewDressBigButton = '',
        addNewDressSmallButton = '',
        chatCounter;

    if (this.state.event.dresses && this.state.event.dresses.length === 0) {
      addNewDressBigButton = <div className="add-dress-box"><a href={this.props.event_path + '/dresses/new'} className="add">Design a new dress</a></div>;
    } else if (this.state.event.dresses && this.state.event.dresses.length > 0 ) {
      addNewDressSmallButton = <div className="dresses-actions text-center"><a href={this.props.event_path + '/dresses/new'} className="btn-transparent btn-create-a-dress"><em>Design</em> a new dress</a></div>;
    }

    if(this.state.chat.unreadCount > 0){
      chatCounter = <span className="badge">{this.state.chat.unreadCount}</span>;
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
                  <li role="presentation" className="tab-chat hidden" onClick={this.resetUnreadCount}>
                    <a aria-controls="chat-mobile" data-toggle="tab" href="#chat-mobile" role="tab">
                      Chat{chatCounter}
                    </a>
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
