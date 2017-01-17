var Chat = React.createClass({

  propTypes: {
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    user_id: React.PropTypes.number,
    filestack_key: React.PropTypes.string,
    getDresses: React.PropTypes.func,
    setDresses: React.PropTypes.func,
    handleLikeDress: React.PropTypes.func,
    twilioManager: React.PropTypes.object,
    twilioClient: React.PropTypes.object
  },

  getInitialState: function(){
    return {
      messages: [],
      message: '',
      typing: [],
      channelMembers: [],
      twilioClient: null,
      twilioManager: null
    }
  },

  componentWillReceiveProps: function(nextProps){
    if(this.props.twilioManager != nextProps.twilioManager){
      var that = this;
      var accessManager = nextProps.twilioManager;
      var messagingClient = nextProps.twilioClient;
      var channelName = 'wedding-atelier-channel-' + this.props.event_id;
      var notificationsChannelName = 'wedding-atelier-notifications-' + this.props.event_id;

      // notifications channel
      messagingClient.getChannelByUniqueName(notificationsChannelName).then(function(notificationChannel) {
        if (notificationChannel) {
          that.setupNotificationsChannel(notificationChannel);
        } else {
          messagingClient.createChannel({
            uniqueName: notificationsChannelName,
            friendlyName: 'Notifications for: ' + that.props.wedding_name
          }).then(function(notificationChannel) {
              that.setupNotificationsChannel(notificationChannel);
          });
        }
      });
      // normal messaging client
      messagingClient.getChannelByUniqueName(channelName).then(function(channel) {
        if (channel) {
          that.setupChannel(channel);
          that.loadChannelHistory(channel);
          that.loadChannelMembers(channel);
        } else {
          messagingClient.createChannel({
            uniqueName: channelName,
            friendlyName: that.props.wedding_name
          }).then(function(channel) {
              that.setupChannel(channel);
          });
        }
      });

    }
  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  setupNotificationsChannel: function(notificationsChannel) {
    var that = this;

    notificationsChannel.join().then(function(channel) {
      console.log('Joined notifications channel as ' + that.props.username);
    });

    // Listen for new messages sent to the channel
    notificationsChannel.on('messageAdded', function (message) {
      // var messages = that.state.messages.slice();
      var parsedMsg = JSON.parse(message.body);

      if (parsedMsg.type === "dress-like") {
        dresses = that.props.getDresses();

        var index = dresses.findIndex(function(dress) {
          return dress.id === parsedMsg.dress.id;
        });

        dresses[index] = parsedMsg.dress;
        that.props.setDresses(dresses);
      }
    });

    this.notificationsChannel = notificationsChannel;
  },

  setupChannel: function (generalChannel){
    var that = this;

    generalChannel.join().then(function(channel) {
      console.log('Joined channel as ' + that.props.username);
    });

    // Listen for new messages sent to the channel
    generalChannel.on('messageAdded', function (message) {
      var messages = that.state.messages.slice();
      var parsedMsg = JSON.parse(message.body);

      if (parsedMsg.type === "simple") {
        that.refs.chatMessage.value = "";
      }

      messages.push(parsedMsg);
      that.setState({messages: messages});
    });

    generalChannel.on('memberJoined', function(member) {
      that.handleMember(member, true);
    });

    generalChannel.on('memberLeft', function(member) {
      that.handleMember(member, false);
    });

    generalChannel.on('typingStarted', function(member){
      that.setTypingIndicator(member, true);
    });

    generalChannel.on('typingEnded', function(member){
      that.setTypingIndicator(member, false);
    });

    this.generalChannel = generalChannel;
  },

  loadChannelHistory: function(channel) {
    channel.getMessages(20).then(function(messages) {
      var _messages = messages.map(function(message) {
        return JSON.parse(message.body)
      });

      this.setState({messages: _messages});
    }.bind(this));
  },

  handleMember: function(member, joined) {
    var currentState = this.state;
    var user = {
      id: member.sid,
      identity: member.identity,
      online: joined
    };
    var members = currentState.channelMembers.filter(function(onlineMember) { onlineMember.id == user.id});
    members.push(user);

    this.setState({channelMembers: members});
  },

  getChatMembers: function() {
    var chatMembers = this.state.channelMembers.map(function(member, index) {
      className = member.online ? '' : 'text-muted';

      if (index === this.state.channelMembers.length - 1) {
        return(<span className={className} key={'chat-member-' + index}>{member.initials}.</span>);
      } else {
        return(<span className={className} key={'chat-member-' + index}>{member.initials}, </span>);
      }
    }.bind(this));

    return chatMembers;
  },

  loadChannelMembers: function(channel) {
    channel.getMembers().then(function(members) {
      var chatMembers = members.map(function(member) {
        var nameInitials = member.identity.match(/\b\w/g).join("").toUpperCase();

        return {
          id: member.sid,
          identity: member.identity,
          initials: nameInitials,
          online: true
        };
      }.bind(this));

      this.setState({channelMembers: chatMembers.slice(1)});
    }.bind(this));
  },

  uploadImage: function() {
    var picker_options = {};
    filepicker.setKey(this.props.filestack_key);
    filepicker.pick(picker_options,
      function onSuccess(Blob) {
        this.sendMessageImage(Blob);
      }.bind(this),
      function onError(FPError) {},
      function onProgress(FPProgress) {}
    );
  },

  attemptToSendMessage: function(e){
    e.preventDefault();
    var message = this.refs.chatMessage.value;

    if (message) {
      this.sendMessage(message);
    }
  },

  sendMessageTile: function(dress) {
    this.sendMessage(dress, "dress");
  },

  sendMessageImage: function(image) {
    this.sendMessage(image, "image");
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

    this.generalChannel.sendMessage(JSON.stringify(message));
  },

  sendNotification: function(message) {
    this.notificationsChannel.sendMessage(JSON.stringify(message));
  },

  getRenderedMessages() {
    var msgs = this.state.messages.slice();
    var tempAuthor = null;
    var showAuthor = true;
    var isOwnerMessage = true;
    var userId = this.props.user_id;

    if (msgs[0]) {
      tempAuthor = msgs[0].author;
    }

    var messages = msgs.map(function(message, index) {
      if (tempAuthor === message.author && index !== 0) {
        showAuthor = false;
      } else {
        tempAuthor = message.author;
        showAuthor = true;
      }

      isOwnerMessage = userId === message.user_id;

      var msgComp = null;

      if(message.type === 'simple') {
        msgComp = (<ChatSimpleMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"simple-message" + index}/>);
      } else if (message.type === 'dress') {

        dresses = this.props.getDresses();
        var dress = dresses.find(function(dress) {
          return dress.id === message.content.id ? dress : null ;
        });
        if (dress) {
          // referencing directly the dress
          message.content = dress;
        }
        // Forming the mssage with the component...
        msgComp = (<ChatDressMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"dress-message" + index} handleLikeDress={this.props.handleLikeDress} />);
      } else if (message.type === 'image') {
        msgComp = (<ChatImageMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"image-message" + index}/>);
      }
      tempAuthor = message.author;

      return msgComp;
    }.bind(this));

    return messages;
  },

  startTyping: function() {
    this.generalChannel.typing();
  },

  getWhoisTyping: function() {
    var members = this.state.typing.map(function(member) {
      return (
        <div>
          <div className="typing">
            <img src="/assets/wedding-atelier/typing.svg" />
          </div>
          <div className="msg msg-data">
            <div className="profile">
              <img className="photo" src="/assets/profile-placeholder.jpg" />
              <span className="name">{member}</span>
            </div>
          </div>
        </div>
      );
    });

    return (
      <div className="row">
        <div className="col-xs-12">
          {members}
        </div>
      </div>
    );
  },

  setTypingIndicator: function(member, typing){
    var whoIsTyping = this.state.typing.slice();
    var isAlreadyTyping = whoIsTyping.indexOf(member.identity) > -1;

    if (typing && !isAlreadyTyping) {
      whoIsTyping.push(member.identity);
    } else {
      var index = whoIsTyping.indexOf(member.identity);
      whoIsTyping.splice(index, 1);
    }

    this.setState({typing: whoIsTyping});
  },

  scrollToBottom: function(){
    var scroll = function() {
      var elem = this.refs.chatLog;
      if (!elem) { return; }
      elem.scrollTop = elem.scrollHeight;
    }.bind(this);

    scroll();
    $(window).resize(function(e) {
      scroll();
    });

    $('img', this.refs.chatLog).on('load', scroll);
  },

  render: function(){
    var messages = this.getRenderedMessages();
    var typing = this.getWhoisTyping();
    var chatMembers = this.getChatMembers();

    return(
      <div className="chat row">
        <div className="chat-general-info center-block">
          <div className="row">
            <div className="col-xs-7">
              <div className="chat-header-left-side">
                <strong>Online</strong>: {chatMembers}
              </div>
            </div>
            <div className="col-xs-5">
              <div className="chat-header-right-side pull-right">
                <strong>Fame stylist: </strong><span className="stylist-name">Amber: </span><img src="/assets/profile-placeholder.jpg" className="stylist-photo" />
              </div>
            </div>
          </div>
        </div>
        <div className="chat-log" ref="chatLog">
          {messages}

          <div className='chat-typing'>
            {typing}
          </div>
        </div>
        <form onSubmit={this.attemptToSendMessage} className="chat-actions">
          <input className="btn upload-image" onClick={this.uploadImage} value="" />
          <div className="message-input">
            <input type="text"
                   value={this.message}
                   id='chat-message'
                   onChange={this.startTyping}
                   ref="chatMessage"
                   placeholder="Start typing..." />
          </div>
          <div className="btn-send-container">
            <input value="send" className="btn btn-black btn-send-msg-to-chat" type="submit"/>
          </div>
        </form>
      </div>
    )
  }
});
