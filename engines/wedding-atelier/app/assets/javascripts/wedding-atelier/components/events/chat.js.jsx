var Chat = React.createClass({

  propTypes: {
    profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    current_user: React.PropTypes.object,
    user_id: React.PropTypes.number,
    filestack_key: React.PropTypes.string,
    handleLikeDress: React.PropTypes.func,
    changeDressToAddToCartCallback: React.PropTypes.func,
    startTypingFn: React.PropTypes.func,
    sendMessageFn: React.PropTypes.func,
    messages: React.PropTypes.array,
    members: React.PropTypes.array,
    typing: React.PropTypes.array,
    dresses: React.PropTypes.array,
    loading: React.PropTypes.bool,
    event: React.PropTypes.object,
    event_url: React.PropTypes.string
  },

  getInitialState: function(){
    return {
      dresses: this.props.dresses,
      message: '',
      messages: this.props.messages,
      members: this.props.members,
      typing: this.props.typing,
      showTags: false
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
    var message = this.refs.autocompleteInput.refs.input.value;

    if (message) {
      this.props.sendMessageFn(message).then(function() {
        this.refs.autocompleteInput.refs.input.value = '';
        this.sendToSlack(message);
      }.bind(this));
    }
  },

  sendToSlack: function(message){
    var user = this.props.current_user,
        event = this.props.event,
        adminLink = '<' + this.props.event_url + '>',
        hook = 'https://hooks.slack.com/services/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';

    var fullMessage = user.name + ' (' + user.email + '): ' + message + '\n'
        + adminLink + '\n'
        + 'Wedding Date: ' + event.date + '\n'
        + 'Dresses in board: ' + event.dresses.length + '\n'
        + 'Cart value: ' + event.current_cart_total + '\n'
        + 'Date joined: ' + user.joined_at;

    var slackMessage = {
      attachments: [
        {
          text: message,
          fields: [
            {
              title: 'User',
              value: user.name + ' (' + user.email + ')'
            },
            {
              title: 'Board link',
              value: this.props.event_url
            },
            {
              title: 'Wedding date',
              value: event.date,
              short: true
            },
            {
              title: 'Dresses in board',
              value: event.dresses.length,
              short: true
            },
            {
              title: 'Cart value',
              value: event.current_cart_total,
              short: true
            },
            {
              title: 'Date joined',
              value: user.joined_at,
              short: true
            }
          ]
        }
      ]

    }
    if(!user.fame_staff) {
      $.ajax({
        url: hook,
        type: 'POST',
        data: 'payload=' + JSON.stringify(slackMessage),
        dataType: 'json'
      });
    }
  },

  sendMessageTile: function(dress) {
    return this.sendMessage(dress, "dress");
  },

  sendMessageImage: function(image) {
    return this.sendMessage(image, "image");
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

    return this.props.sendMessageFn(message);
  },

  getRenderedMessages() {
    var msgs = this.state.messages.slice();
    var tempAuthor = null;
    var showAuthor = true;
    var isOwnerMessage = true;
    var userId = this.props.user_id;

    if (msgs[0]) { tempAuthor = msgs[0].author; }

    var messages = msgs.map(function(message, index) {
      if (tempAuthor === message.author && index !== 0) {
        showAuthor = false;
      } else {
        tempAuthor = message.author;
        showAuthor = true;
      }

      isOwnerMessage = userId === message.user_id;
      tempAuthor = message.author;

      return {
        simple: this.simpleMessageComponent,
        notification: this.notificationMessageComponent,
        sms: this.smsMessageComponent,
        dress: this.dressMessageComponent,
        image: this.imageMessageComponent
      }[message.type](message, showAuthor, isOwnerMessage, index);
    }.bind(this));

    return messages;
  },

  smsMessageComponent: function(message, showAuthor, isOwnerMessage, key) {
    return(<ChatSMSMessage key={"sms-message" + key}/>);

  },

  simpleMessageComponent: function(message, showAuthor, isOwnerMessage, key) {
    return(<ChatSimpleMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"simple-message" + key}/>);
  },

  notificationMessageComponent: function(message, showAuthor, isOwnerMessage, key){
    return(<ChatSimpleMessage showAuthor={false} isOwnerMessage={false} message={message} key={"simple-message" + key}/>);
  },

  dressMessageComponent: function(message, showAuthor, isOwnerMessage, key) {
    var dresses = [...this.state.dresses];
    var dress = _.findWhere(dresses, {id: message.content.id});

    if (dress) {
      message.content = dress;
    }
    // Forming the mssage with the component...
    return (<ChatDressMessage showAuthor={showAuthor}
                                 isOwnerMessage={isOwnerMessage}
                                 message={message}
                                 key={"dress-message" + key}
                                 handleLikeDress={this.props.handleLikeDress}
                                 changeDressToAddToCartCallback={this.props.changeDressToAddToCartCallback}/>);
  },

  imageMessageComponent: function(message, showAuthor, isOwnerMessage, key){
    return(<ChatImageMessage showAuthor={showAuthor} isOwnerMessage={isOwnerMessage} message={message} key={"image-message" + key}/>);
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

  getWelcomeMessage: function(){
    if(!this.state.messages.length){
      return(
        <div className="chat-welcome-message">
          <div className="welcome-message-content">
            <h2 className="welcome-message-title"> Welcome to your Wedding Board </h2>
            <p> You can get started by either: </p>
            <ol>
              <li><p>Talking to a fame stylist by tagging <span className="stylist-tag">@Stylist</span> in chat</p></li>
              <li><p> Invite and chat with your bridal party</p></li>
              <li><p> Start adding dresses to your dress board to vote and share with your bridal party</p></li>
            </ol>
          </div>
        </div>
      );
    }
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

  chatContent: function(){
    if(this.props.loading){
      return (<ImageLoader loading={this.props.loading}/>);
    }else if(this.state.messages.length){
      return this.getRenderedMessages();
    }else{
      return this.getWelcomeMessage();
    }
  },

  render: function(){
    var messages = this.getRenderedMessages(),
        typing = this.getWhoisTyping(),
        chatMembers = this.getChatMembers(),
        chatWelcomeMessage = this.getWelcomeMessage();

    return(
      <div className="chat row">
        <div className="chat-general-info center-block">
          <div className="row">
            <div className="col-xs-12">
              <div className="chat-header-left-side">
                <strong className="walkthrough-messages" title="See who's online" data-content="Then start chatting." data-placement="bottom">Online</strong>: {chatMembers}
              </div>
            </div>
          </div>
        </div>
        <div
          className="chat-log walkthrough-messages"
          ref="chatLog"
          title="Chat with your bridal party and stylists"
          data-content="Share your designs and discuss each look."
          data-placement="right">
          {this.chatContent()}
          <div className="chat-typing">
            {typing}
          </div>
          <div className="chat-tagging-help">
            <p> Type <b>@Stylist</b> to message a fame stylist </p>
          </div>
        </div>
        <form onSubmit={this.attemptToSendMessage} className="chat-actions">
          <input className="btn upload-image walkthrough-messages" onClick={this.uploadImage} value="" data-content="Send pics to the group" data-placement="right" />
          <AutocompleteInput
            ref="autocompleteInput"
            changeHandler={this.props.startTypingFn}
            initialItems={['stylist']}
          />
          <div className="btn-send-container">
            <input value="send" className="btn btn-black btn-send-msg-to-chat" type="submit"/>
          </div>
        </form>
      </div>
    );
  }
});
