var Chat = React.createClass({

  propTypes: {
    profile_photo: React.PropTypes.string,
    bot_profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    user_id: React.PropTypes.number,
    filestack_key: React.PropTypes.string,
    handleLikeDress: React.PropTypes.func,
    changeDressToAddToCartCallback: React.PropTypes.func,
    startTypingFn: React.PropTypes.func,
    sendMessageFn: React.PropTypes.func,
    messages: React.PropTypes.array,
    members: React.PropTypes.array,
    typing: React.PropTypes.array,
    dresses: React.PropTypes.array
  },

  getInitialState: function(){
    return {
      dresses: this.props.dresses,
      message: '',
      messages: this.props.messages,
      members: this.props.members,
      typing: this.props.typing
    }
  },

  componentWillReceiveProps: function(nextProps) {
    var _state = $.extend({}, this.state),
        stateChanged = false,
        that = this;

    ['messages', 'members', 'typing', 'dresses'].forEach(function(propName) {
      if (nextProps[propName].length !== that.state[propName].length) {
        _state[propName] = nextProps[propName];
        stateChanged = true;
      }
    });

    if (stateChanged) {
      this.setState(_state);
    }
  },

  componentDidUpdate: function() {
    this.scrollToBottom();
  },

  getChatMembers: function() {
    var that = this;

    var chatMembers = this.state.members.map(function(member, index) {
      className = member.online ? '' : 'text-muted';

      var separator = ', ';
      if (index === that.state.members.length - 1) {
        separator == '.';
      }

      return <span className={className} key={'chat-member-' + index}>{member.initials}{separator}</span>;
    });

    return chatMembers;
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
      this.props.sendMessageFn(message).then(function() {
        this.refs.chatMessage.value = '';
      }.bind(this));
    }
  },

  sendMessageImage: function(image) {
    return this.props.sendMessageFn(image, "image");
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

        var dresses = [...this.state.dresses];
        var dress = _.findWhere(dresses, {id: message.content.id});

        if (dress) {
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
    this.props.startTypingFn();
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
