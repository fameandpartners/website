var Chat = React.createClass({
  getInitialState: function(){
    return({
      generalChannel: null,
      messages: [],
      message: '',
      typing: [],
      channelMembers: []
    })
  },

  componentWillMount: function(){
    $.post(this.props.twilio_token_path, function(data) {
      username = data.username;
      var accessManager = new Twilio.AccessManager(data.token);
      var messagingClient = new Twilio.IPMessaging.Client(accessManager);

      var channelName = 'wedding-channel-' + this.props.event_id;
      messagingClient.getChannelByUniqueName(channelName).then(function(channel) {
        if (channel) {
          this.setupChannel(channel);
          this.loadChannelHistory(channel);
          this.loadChannelMembers(channel);
        } else {
          messagingClient.createChannel({
            uniqueName: channelName,
            friendlyName: this.props.wedding_name })
              .then(function(channel) {
                this.setupChannel(channel);
              }.bind(this));
        }
      }.bind(this));
    }.bind(this));
  },

  componentDidMount: function(){
    this.scrollToBottom();
  },

  scrollToBottom: function(){

    var scroll = function() {
      // Scrolling to bottom
      var elem = this.refs.chatLog;
      elem.scrollTop = elem.scrollHeight;
    }.bind(this);

    $(window).resize(function(e) { scroll(); });
  },

  loadChannelHistory: function(channel) {
    channel.getMessages().then(function(messages) {
      currentState = this.state;
      currentState.messages = messages.map(function(message) {
        return JSON.parse(message.body)
      });
      this.setState(currentState);
      this.scrollToBottom();
    }.bind(this));
  },

  setupChannel: function (generalChannel){
    currentState = this.state;
    currentState.generalChannel = generalChannel;
    this.setState(currentState);
    this.state.generalChannel.join().then(function(channel) {
      console.log('Joined channel as ' + username);
    }.bind(this));

    // Listen for new messages sent to the channel
    this.state.generalChannel.on('messageAdded', function (message) {
      var parsedBody = JSON.parse(message.body);
      currentState = this.state;
      currentState.messages.push(parsedBody);
      this.setState(currentState);
      this.scrollToBottom();
    }.bind(this));
    this.state.generalChannel.on('memberJoined', function(member) {
      this.handleMember(member, true)
    }.bind(this));
    this.state.generalChannel.on('memberLeft', function(member) {
      this.handleMember(member, false)
    }.bind(this));
    this.state.generalChannel.on('typingStarted', function(member){
      this.typingIndicator(member.identity, true);
    }.bind(this));
    this.state.generalChannel.on('typingEnded', function(member){
      this.typingIndicator(member.identity, false);
    }.bind(this));
  },

  loadChannelMembers: function(channel) {
    channel.getMembers().then(function(members) {
      var chatMembers = members.map(function(member) {
        return({id: member.sid, identity: member.identity, online: true})
      });
      var currentState = this.state;
      currentState.channelMembers = chatMembers;
      this.setState(currentState);
    }.bind(this));
  },

  handleMember: function(member, joined) {
    var currentState = this.state;
    var user = {id: member.sid, identity: member.identity, online: joined}
    var members = currentState.channelMembers.filter(function(onlineMember) { onlineMember.id == user.id});
    members.push(user);
    currentState.channelMembers = members;
    this.setState(currentState);
  },

  typingIndicator: function(identity, typing){
    currentState = this.state;
    if (typing) {
      currentState.typing.push(identity);
    } else {
      index = currentState.typing.indexOf(identity);
      currentState.typing.splice(index, 1);
    }
    this.setState(currentState);
  },

  sendMessage: function (){
    message = {
      profilePhoto: this.props.profile_photo,
      author: this.props.username,
      time: Date.now(),
      type: 'simple',
      content: this.state.message
    };
    this.state.generalChannel.sendMessage(JSON.stringify(message)).then(function(resposne) {
      $('#chat-message').val('');
    });
  },

  updateMessageContent: function(e){
    message = e.target.value;
    currentState = this.state;
    currentState.message = message;
    this.setState(currentState)
    this.state.generalChannel.typing();
  },

  attemptToSendMessage: function(e){
    if (e.keyCode == 13) {
      this.sendMessage();
    }
  },

  render: function(){
    var messages = this.state.messages.map(function(message, index){
      if(message.type == 'simple') {
        return (<ChatSimpleMessage message={message} key={"simple-message" + index}/>);
      }
    });

    var typing = this.state.typing.length > 0 ? 'Now typing...' + this.state.typing.join(", ") : '';

    var chatMembers = this.state.channelMembers.map(function(member, index) {
      className = member.online ? '' : 'text-muted';
      return(<span className={className} key={'chat-member-' + index}>{member.identity}, </span>);
    });

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
          <div className="msg-image">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="attachment">
              <img src="uploadedimagsource" />
            </div>
          </div>
          {messages}
        </div>
        <div className='chat-typing'>
          {typing}
        </div>
        <div className="chat-actions">
          <button className="btn upload-image"></button>
          <div className="message-input">
            <input type="text"
                   value={this.message}
                   id='chat-message'
                   onChange={this.updateMessageContent}
                   onKeyDown={this.attemptToSendMessage}/>
          </div>
          <div className="btn-send-container">
            <button className="btn btn-black btn-send-msg-to-chat" onClick={this.sendMessage}>send</button>
          </div>
        </div>
      </div>
    )
  }
});
