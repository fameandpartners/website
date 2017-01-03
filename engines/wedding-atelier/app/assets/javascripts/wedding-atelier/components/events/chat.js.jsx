var Chat = React.createClass({

  propTypes: {
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    user_id: React.PropTypes.number
  },

  getInitialState: function(){
    return {
      messages: [],
      message: '',
      typing: [],
      channelMembers: []
    }
  },

  componentWillMount: function(){
    var that = this;

    $.post(that.props.twilio_token_path, function(data) {
      var accessManager = new Twilio.AccessManager(data.token);
      var messagingClient = new Twilio.IPMessaging.Client(accessManager);
      var channelName = 'wedding-atelier-channel-' + that.props.event_id;

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
    });

  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  scrollToBottom: function(){
    var scroll = function() {
      // Scrolling to bottom
      var elem = this.refs.chatLog;
      elem.scrollTop = elem.scrollHeight;
    }.bind(this);

    scroll();
    $(window).resize(function(e) {
      scroll();
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
      that.typingIndicator(member.identity, true);
    });

    generalChannel.on('typingEnded', function(member){
      that.typingIndicator(member.identity, false);
    });

    this.generalChannel = generalChannel;
  },

  loadChannelMembers: function(channel) {
    channel.getMembers().then(function(members) {
      var chatMembers = members.map(function(member) {
        return {
          id: member.sid,
          identity: member.identity,
          online: true
        };
      });
      this.setState({channelMembers: chatMembers});
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

  typingIndicator: function(identity, typing){
    var index = null;
    var typing = this.state.typing;

    if (typing) {
      typing.push(identity);
    } else {
      index = typing.indexOf(identity);
      typing.splice(index, 1);
    }

    this.setState({typing: typing});
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

  sendMessageTile: function(dress) {
    this.sendMessage(dress, "dress");
  },

  attemptToSendMessage: function(e){
    e.preventDefault();
    var message = this.refs.chatMessage.value;

    if (message) {
      this.sendMessage(message);
    }
  },

  getMessages() {
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

      if(message.type === 'simple') {
        return (<ChatSimpleMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"simple-message" + index}/>);
      } else if (message.type === 'dress') {
        return (<ChatDressMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"dress-message" + index}/>);
      }
      tempAuthor = message.author;
    });

    return messages;
  },

  getChatMembers: function() {
    var chatMembers = this.state.channelMembers.map(function(member, index) {
      className = member.online ? '' : 'text-muted';
      return(<span className={className} key={'chat-member-' + index}>{member.identity}, </span>);
    });

    return chatMembers;
  },

  getWhoisTyping: function() {
    return this.state.typing.length > 0 ? 'Now typing...' + this.state.typing.join(", ") : '';
  },

  render: function(){
    var messages = this.getMessages();
    var typing = this.getWhoisTyping();
    var chatMembers = this.getChatMembers();

    return(
      <div className="chat">
        <div className="chat-general-info center-block">
          <div className="chat-header-left-side pull-left">
            <strong>Who's online</strong>:
            {chatMembers}
          </div>
          <div className="chat-header-right-side pull-right">
            <strong>Fame stylist online: </strong><span className="stylist-name">Amber: </span><img src="http://localhost:3000/assets/profile-placeholder.jpg" className="stylist-photo" />
          </div>
        </div>
        <div className="chat-log" ref="chatLog">
          {messages}
        </div>
        <div className='chat-typing'>
          {typing}
        </div>
        <form onSubmit={this.attemptToSendMessage} className="chat-actions">
          <button className="btn upload-image"></button>
          <div className="message-input">
            <input type="text"
                   value={this.message}
                   id='chat-message'
                   ref="chatMessage" />
          </div>
          <div className="btn-send-container">
            <input value="send" className="btn btn-black btn-send-msg-to-chat" type="submit"/>
          </div>
        </form>
      </div>
    )
  }
});
