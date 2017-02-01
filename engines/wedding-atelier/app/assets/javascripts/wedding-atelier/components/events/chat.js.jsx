var Chat = React.createClass({

  propTypes: {
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    profile_photo: React.PropTypes.string,
    bot_profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    user_id: React.PropTypes.number,
    filestack_key: React.PropTypes.string,
    getDresses: React.PropTypes.func,
    handleLikeDress: React.PropTypes.func,
    twilioManager: React.PropTypes.object,
    twilioClient: React.PropTypes.object,
    changeDressToAddToCartCallback: React.PropTypes.func
  },

  getInitialState: function(){
    return {
      messages: [],
      message: '',
      typing: [],
      channelMembers: [],
      twilioClient: null,
      twilioManager: null,
      channel: null
    }
  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  setUpMessagingEvents: function(channel) {
    var that = this;

    that.setState({channel: channel});

    // Listen for new messages sent to the channel
    channel.on('messageAdded', function (message) {
      var messages = that.state.messages.slice();
      var parsedMsg = JSON.parse(message.body);

      if (parsedMsg.type === "simple") {
        that.refs.chatMessage.value = "";
      }

      messages.push(parsedMsg);
      that.setState({messages: messages});
    });

    channel.on('memberJoined', function(member) {
      that.handleMember(member, true);
    });

    channel.on('memberLeft', function(member) {
      that.handleMember(member, false);
    });

    channel.on('typingStarted', function(member){
      that.setTypingIndicator(member, true);
    });

    channel.on('typingEnded', function(member){
      that.setTypingIndicator(member, false);
    });
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
    var _newState = $.extend({}, this.state);
    var _newUser = {
      id: member.sid,
      identity: member.identity,
      initials: member.identity.match(/\b\w/g).join("").toUpperCase(),
      online: joined
    };

    _newState.channelMembers.push(_newUser);
    this.setState(_newState);
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

    return this.state.channel.sendMessage(JSON.stringify(message));
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

    return this.state.channel.sendMessage(JSON.stringify(message));
  },

  setNotificationsChannel: function(notificationsChannel) {
    this.setState({notificationsChannel: notificationsChannel});
  },

  sendNotification: function(message) {
    this.state.notificationsChannel.sendMessage(JSON.stringify(message));
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
        msgComp = (<ChatDressMessage showAuthor={showAuthor}
                                     isOwnerMessage={isOwnerMessage}
                                     message={message}
                                     key={"dress-message" + index}
                                     handleLikeDress={this.props.handleLikeDress}
                                     changeDressToAddToCartCallback={this.props.changeDressToAddToCartCallback}/>);
      } else if (message.type === 'image') {
        msgComp = (<ChatImageMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"image-message" + index}/>);
      }
      tempAuthor = message.author;

      return msgComp;
    }.bind(this));

    return messages;
  },

  startTyping: function() {
    this.state.channel.typing();
  },

  getWhoisTyping: function() {
    var members = this.state.typing.map(function(member, index) {
      var typingId = 'whos-typing-' + index;
      return (
        <div key={typingId}>
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
      <div className="container-fluid">
        <div className="row">
          <div className="col-xs-12">
            {members}
          </div>
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
                <strong className="walkthrough-messages" title="See who's online" data-content="Then start chatting." data-placement="bottom">Online</strong>: {chatMembers}
              </div>
            </div>
            <div className="col-xs-5">
              <a href="https://www.fameandpartners.com/wedding-consultation" target="_blank" className="chat-header-right-side pull-right">
                <img className="stylist-photo" src="/assets/wedding-atelier/amber.png" />
                <span className="walkthrough-messages" title="Invite a stylist to join" data-content="Here's how to request a stylist to help the entire bridal party decide on the dress. She'll even offer advice on styling, accessories, hair, makeup, and more." data-placement="bottom"> INVITE A STYLIST </span>
              </a>
            </div>
          </div>
        </div>
        <div
          className="chat-log walkthrough-messages"
          ref="chatLog"
          title="Chat with your bridal party and stylists"
          data-content="Share your designs and discuss each look."
          data-placement="right">
          {messages}

          <div className="chat-typing">
            {typing}
          </div>
        </div>
        <form onSubmit={this.attemptToSendMessage} className="chat-actions">
          <input className="btn upload-image walkthrough-messages" onClick={this.uploadImage} value="" data-content="Send pics to the group" data-placement="right" />
          <div className="message-input">
            <input type="text"
                   value={this.message}
                   id="chat-message"
                   onChange={this.startTyping}
                   ref="chatMessage"
                   placeholder="Start typing..." />
          </div>
          <div className="btn-send-container">
            <input value="send" className="btn btn-black btn-send-msg-to-chat" type="submit"/>
          </div>
        </form>
      </div>
    );
  }
});
