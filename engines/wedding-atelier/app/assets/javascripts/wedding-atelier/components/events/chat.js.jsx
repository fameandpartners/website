var Chat = React.createClass({

  propTypes: {
    profile_photo: React.PropTypes.string,
    current_user: React.PropTypes.object,
    current_cart_total: React.PropTypes.string,
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
    event_url: React.PropTypes.string,
    slack_webhook: React.PropTypes.string
  },

  getInitialState: function(){
    return {
      dresses: this.props.dresses,
      message: '',
      messages: this.props.messages,
      members: this.props.members,
      typing: this.props.typing,
      showTags: false
    };
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
      var className = member.online ? '' : 'text-muted';

      var separator = ', ';
      if (index === that.state.members.length - 1) {
        separator = '.';
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
        staffOnline = _.findWhere(this.props.members, { identity: 'Amber (Fame Stylist)' });
    var slackMessage = {
      attachments: [
        {
          text: message,
          callback_id: 'cust_sup',
          fields: [
            {
              title: 'User',
              value: user.name + ' (' + user.email + ')'
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
              value: this.props.current_cart_total,
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
    };

    if(!staffOnline){
      slackMessage.attachments[0].actions =
        [
          {
            name: 'reply',
            text: 'Reply',
            type: 'button',
            value: this.props.event_url,
            style: 'primary'
          }
        ];
    }

    if(!user.fame_staff) {
      $.ajax({
        url: this.props.slack_webhook,
        type: 'POST',
        data: 'payload=' + JSON.stringify(slackMessage),
        dataType: 'json'
      });
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
    var dress = _.findWhere(this.state.dresses, {id: message.content.id});

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
            <h2 className="welcome-message-title">Welcome to your Atelier App wedding board </h2>
            <p> Here's how to get started: </p>
            <ol>
              <li><p>Invite the members of your bridal party to join the wedding board.</p></li>
              <li><p>Get advice from a Fame stylist by tagging <span className="stylist-tag">@stylist</span> in your chat.</p></li>
              <li><p>Add dresses to your board to share with the group and vote on your favorites.</p></li>
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
