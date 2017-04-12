var MoodBoardEvent = React.createClass({

  propTypes: {
    channel_prefix: React.PropTypes.string,
    current_user_id: React.PropTypes.number,
    current_user: React.PropTypes.object,
    current_cart_total: React.PropTypes.string,
    dress: React.PropTypes.object,
    dresses_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    event_path: React.PropTypes.string,
    event_url: React.PropTypes.string,
    filestack_key: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
    roles_path: React.PropTypes.string,
    send_invite_path: React.PropTypes.string,
    siteVersion: React.PropTypes.string,
    sizing_path: React.PropTypes.string,
    twilio_token_path: React.PropTypes.string,
    user_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
    slack_webhook: React.PropTypes.string
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
        unreadCount: 0,
        loading: true,
        messagesCount: 0,
        loadHistory: true
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

  componentDidMount: function(){
    $(window).on('beforeunload', function(){
      this.state.chatChannel.leave();
    }.bind(this));

    _cio.identify({
      id: this.props.current_user.id,
      email: this.props.current_user.email,
      created_at: this.props.current_user.created_at
    });
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
      that.refs.notifications.notify(['Sorry, there was a problem starting your chat session. We\'ll have it back up and running soon.']);
    });
  },

  setupChatChannel: function(){
    var that = this;
    var chatChannelName = this.props.channel_prefix + 'wedding-atelier-channel-' + this.props.event_id;
    this.state.twilioClient.getChannelByUniqueName(chatChannelName).then(function(chatChannel){
      chatChannel.join().then(function() {
        that.setState({ chatChannel: chatChannel });
        that.setUpMessagingEvents();
        that.loadMessagesCountAndHistory();
        that.loadChannelMembers();
      });

    }, function(e){
      if(e.body.code == that.twilioCodes.CHANNEL_NOT_FOUND){
        that.state.twilioClient.createChannel({
          uniqueName: chatChannelName,
          friendlyName: that.props.wedding_name
        }).then(function(chatChannel) {
          chatChannel.join().then(function() {
            var _chat = $.extend({}, that.state.chat);
            _chat.loading = false;
            that.setState({ chatChannel: chatChannel, chat: _chat });
            that.setUpMessagingEvents();
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
        that.setUpNotificationListeners();
      });
    }, function(e){
      that.state.twilioClient.createChannel({
        uniqueName: notificationsChannelName,
        friendlyName: 'Notifications for: ' + that.props.wedding_name
      }).then(function(channelNotifications) {
        that.setState({channelNotifications: channelNotifications});
        that.state.channelNotifications.join().then(function(channel) {
          that.setUpNotificationListeners();
        });
      });
    });
  },

  startTyping: function() {
    this.state.chatChannel.typing();
  },

  setTypingIndicator: function(member, typing){
    var _whoIsTyping = [...this.state.chat.typing];
    var _isAlreadyTyping = _whoIsTyping.indexOf(member.userInfo.identity) > -1;

    if (typing && !_isAlreadyTyping) {
      _whoIsTyping.push(member.userInfo.identity);
    } else {
      var index = _whoIsTyping.indexOf(member.userInfo.identity);
      _whoIsTyping.splice(index, 1);
    }

    var _chat = $.extend({}, this.state.chat);
    _chat.typing = _whoIsTyping;
    this.setState({chat: _chat});
  },

  tagStylistCallback: function(message){
    var regExp = new RegExp('@stylist', 'i');
    if(regExp.test(message.content)){

      this.sendMessageToTwillio({
        author: null,
        time: Date.now(),
        type: 'notification',
        content: 'Our Fame stylist generally gets back to you within the hour. You will be notified via email when she replies.'
      }).then(function(){
        if(!sessionStorage.getItem('stylistTagged')){
          this.sendMessageToTwillio({
            author: null,
            time: Date.now(),
            type: 'notification',
            content: 'In the meantime why don\'t you invite your bridal party if you haven\'t already. Remember you can create and discuss dresses with them via chat.'
          });
          try { sessionStorage.setItem('stylistTagged', true); }catch (e){}
        }
      }.bind(this));
    }
  },

  sendMessageToTwillio: function(message) {
    var promise = this.state.chatChannel.sendMessage(JSON.stringify(message));
    promise.then(this.tagStylistCallback.bind(this, message));
    return promise;
  },

  sendNotificationToTwillio: function(message) {
    return this.state.channelNotifications.sendMessage(JSON.stringify(message));
  },

  loadChannelMembers: function() {
    var that = this;
    this.state.chatChannel.getMembers().then(function(members) {
      var chatMembers = members.map(function(member) {
        var nameInitials = member.userInfo.identity.match(/\b\w/g).join("").toUpperCase();
        var assistant = _.findWhere(that.state.event.assistants, { name: member.userInfo.identity }) || {};

        return {
          id: member.sid,
          internalId: assistant.id,
          identity: member.userInfo.identity,
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

  loadMessagesCountAndHistory: function(){
    var that = this;
    this.state.chatChannel.getMessagesCount().then(function(messagesCount){
      var _chat = $.extend({}, that.state.chat);
      _chat.messagesCount = messagesCount;
      that.setState({ chat: _chat });
      var historyPromise = that.loadChannelHistory(20);
      if(historyPromise){
        historyPromise.then(function(){
          that.refs.ChatComp.scrollToBottom();
          that.refs.MobileChatComp.scrollToBottom();
        });
      }
    });
  },

  loadChannelHistory: function(pageSize){
    var that = this;
    if(this.state.chat.loadHistory){
      var anchor = this.state.chat.messagesCount - this.state.chat.messages.length;
      return that.state.chatChannel.getMessages(pageSize, anchor).then(function(messages) {
        var _chat = $.extend({}, that.state.chat);
        var _messages = messages.items.map(function(message) {
          return JSON.parse(message.body);
        });
        _chat.messages = _messages.concat(_chat.messages);
        _chat.loading = false;
        _chat.loadHistory = messages.hasPrevPage;
        _chat.historyAnchor += messages.length;
        that.setState({chat: _chat});
      });
    }
  },

  handleMember: function(member, joined) {
    var _newChat = $.extend({}, this.state.chat);
    if (joined) {
      var assistant = _.findWhere(this.state.event.assistants, { name: member.userInfo.identity }) || {};

      var newMember = {
        id: member.sid,
        internalId: assistant.id,
        identity: member.userInfo.identity,
        initials: member.userInfo.identity.match(/\b\w/g).join("").toUpperCase(),
        online: joined
      };

      _newChat.members.push(newMember);
      this.setState({ chat: _newChat });
    } else {
      _newChat.members = _.reject(_newChat.members, function(chatMember){
        return chatMember.id === member.sid;
      });
      this.setState({ chat: _newChat });
    }
  },

  setUpMessagingEvents: function() {
    var that = this;

    this.state.chatChannel.on('messageAdded', function (message) {
      var _messages = [...that.state.chat.messages];
      var parsedMsg = JSON.parse(message.body);
      _messages.push(parsedMsg);

      if(parsedMsg.staffMessage && !sessionStorage.getItem('chatNotificationSent')){
        var onlineMembersIds = _.pluck(that.state.chat.members, 'internalId');
        that.state.event.assistants.map(function(assistant){
          if(onlineMembersIds.indexOf(assistant.id) < 0){
            _cio.track('wedding_atelier_chat_notification', { recipient: assistant.email, message: parsedMsg.content, moodboard_url: that.props.event_url });
          }
        });
        try { sessionStorage.setItem('chatNotificationSent', true); }catch(e){}
      }

      var _chat = $.extend({}, that.state.chat);
      _chat.messages = _messages;
      if(!$('.tab-chat').hasClass('active')) {
        _chat.unreadCount++;
      }
      that.setState({chat: _chat});
      that.refs.ChatComp.scrollToBottom();
      that.refs.MobileChatComp.scrollToBottom();
    });

    this.state.chatChannel.on('memberJoined', function(member) {
      that.handleMember(member, true);
    });

    this.state.chatChannel.on('memberLeft', function(member) {
      // TODO: make sure this works.
      that.handleMember(member, false);
    });

    this.state.chatChannel.on('typingStarted', function(member){
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
        that.refs.notifications.notify([error.statusText]);
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
    _newEvent.hasError = {};
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
    var that = this;
    $.ajax({
      url: this.props.remove_assistant_path.replace(':id', id),
      type: 'DELETE',
      dataType: 'json',
      success: function(_data) {
        var _newEvent = $.extend({}, that.state.event);
        _newEvent.assistants.splice(index, 1);
        that.setState({event: _newEvent});
        that.refs.notifications.notify(['Board member removed.']);
      },
      error: function(_data) {
        var errors;
        try{
          errors = JSON.parse(_data.responseText).errors;
        }catch(e){
          errors = ["We're sorry something went wrong."];
        }
        that.refs.notifications.notify(errors[0]);
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
    var author = this.props.current_user.fame_staff ? 'Amber (Fame Stylist)' : this.props.current_user.name;
    message = {
      profilePhoto: this.props.profile_photo,
      author: author,
      user_id: this.props.user_id,
      staffMessage: this.props.current_user.fame_staff,
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
      profile_photo: this.props.profile_photo,
      current_user: this.props.current_user,
      current_cart_total: this.props.current_cart_total,
      user_id: this.props.user_id,
      filestack_key: this.props.filestack_key,
      handleLikeDress: this.handleLikeDress,
      changeDressToAddToCartCallback: this.changeDressToAddToCartCallback,
      loadChannelHistory: this.loadChannelHistory,
      startTypingFn: this.startTyping,
      sendMessageFn: this.sendMessage,
      messages: this.state.chat.messages,
      members: this.state.chat.members,
      typing: this.state.chat.typing,
      dresses: this.state.event.dresses,
      loading: this.state.chat.loading,
      event: this.state.event,
      event_url: this.props.event_url,
      slack_webhook: this.props.slack_webhook
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
        <Notification ref="notifications"/>
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
                    data-tooltip-content="Create new looks and vote on your favorites"
                    data-tooltip-my-position="top center"
                    data-tooltip-at-position="bottom center">
                    <a aria-controls="bridesmaid-dresses" data-toggle="tab" href="#bridesmaid-dresses" role="tab">
                      Bridesmaid dresses</a>
                  </li>
                  <li
                    role="presentation"
                    className="walkthrough-messages"
                    title="Update the details"
                    data-tooltip-content="Input everything you need to know about the big day"
                    data-tooltip-my-position="bottom center"
                    data-tooltip-at-position="top center">
                    <a aria-controls="wedding-details" data-toggle="tab" href="#wedding-details" role="tab">
                    Wedding details</a>
                  </li>
                  <li
                    role="presentation"
                    className="walkthrough-messages"
                    title="Manage the group"
                    data-tooltip-content="Add, view, and remove members of the bridal party"
                    data-tooltip-my-position="top center"
                    data-tooltip-at-position="bottom center">
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
                  <Chat {...$.extend({ mobile: true}, chatProps)}/>
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
                                current_user={this.props.current_user}
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
                <div id="bridal-gowns" className="tab-pane" role="tabpanel" />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
