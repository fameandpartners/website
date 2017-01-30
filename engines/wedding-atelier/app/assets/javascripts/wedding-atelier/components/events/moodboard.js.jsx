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
    siteVersion: React.PropTypes.string,
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
    }
  },

  componentWillMount: function(){
    this.setUpData();
    this.setDefaultTabWhenResize();
  },

  setUpData: function(){
    var that = this;
    var eventPromise = $.getJSON(that.props.event_path + '.json');
    var sizingPromise = $.getJSON(this.props.sizing_path + '.json');
    var twilioPromise = $.post(this.props.twilio_token_path + '.json');

    Promise.all([eventPromise, sizingPromise, twilioPromise]).then(function(values){
      var event = values[0].moodboard_event,
          sizes = values[1].sizing.sizes,
          heights = values[1].sizing.heights,
          token = values[2].token,
          twilioManager = new Twilio.AccessManager(token);

      var _state = $.extend({}, that.state);
      _state.event = event;
      _state.event_backup = event;
      _state.sizes = sizes;
      _state.heights = heights;
      _state.twilioManager = twilioManager;
      _state.twilioClient = new Twilio.IPMessaging.Client(twilioManager);
      that.setState(_state);
      that.setupChatChannels();
    });
  },

  setupChatChannels: function(){
    var _state = $.extend({}, this.state);
    var that = this;
    var channelName = this.props.channel_prefix + 'wedding-atelier-channel-' + this.props.event_id;
    var notificationsChannelName = this.props.channel_prefix + '-wedding-atelier-notifications-' + this.props.event_id;

    // notifications channel
    _state.twilioClient.getChannelByUniqueName(notificationsChannelName).then(function(notificationChannel) {
      if (notificationChannel) {
        that.setupNotificationsChannel(notificationChannel);
      } else {
        _state.twilioClient.createChannel({
          uniqueName: notificationsChannelName,
          friendlyName: 'Notifications for: ' + that.props.wedding_name
        }).then(function(notificationChannel) {
            that.setupNotificationsChannel(notificationChannel);
        });
      }
    });

    // normal messaging client
    _state.twilioClient.getChannelByUniqueName(channelName).then(function(channel) {
      if (channel) {
        channel.join().then(function() {
          console.log('Joined channel as ' + that.props.username);
          that.refs.ChatDesktop.setUpMessagingEvents(channel);
          that.refs.ChatMobileComp.setUpMessagingEvents(channel);
          that.refs.ChatDesktop.loadChannelHistory(channel);
          that.refs.ChatMobileComp.loadChannelHistory(channel);
          that.refs.ChatDesktop.loadChannelMembers(channel);
          that.refs.ChatMobileComp.loadChannelMembers(channel);
        });
      } else {
        _state.twilioClient.createChannel({
          uniqueName: channelName,
          friendlyName: that.props.wedding_name
        }).then(function(channel) {
          channel.join().then(function() {
            that.refs.ChatDesktop.setUpMessagingEvents(channel);
            //It needs a bit time to setup event listeners properly
            setTimeout(function() {
              that.refs.ChatDesktop.sendMessageBot("Welcome to your wedding board! Here's where you can chat with me (the BridalBot), your wedding party, and your Fame stylist to create your custom wedding looks.")
                  .then(function() {
                    return that.refs.ChatDesktop.sendMessageBot("Why don't you begin by creating your first dress?" + '(Just click "ADD YOUR FIRST DRESS" over to the right.) Or, invite a stylist to join your chat to help you get started.')
                  });
            }, 3000);
          });
        });
      }
    });
  },

  setupNotificationsChannel: function(notificationsChannel) {
    var that = this;
    this.refs.ChatDesktop.setNotificationsChannel(notificationsChannel);
    this.refs.ChatMobileComp.setNotificationsChannel(notificationsChannel);

    notificationsChannel.join().then(function(channel) {
      console.log('Joined notifications channel as ' + that.props.username);
    });

    // Listen for new messages sent to the channel
    notificationsChannel.on('messageAdded', function (message) {
      var parsedMsg = JSON.parse(message.body);

      if (parsedMsg.type === "dress-like") {
        var dresses = [...that.state.event.dresses];

        var index = dresses.findIndex(function(dress) {
          return dress.id === parsedMsg.dress.id;
        });

        dresses[index].likes_count = parsedMsg.dress.likes_count;
        that.setDresses(dresses);
      }
    });
  },

  getDresses: function() {
    return this.state.event.dresses;
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
        })
        that.setState(_newState);
      }.bind(this),
      error: function(error) {
        ReactDOM.render(<Notification errors={[error.statusText]} />,
                    $('#notification')[0]);
      }
    })
  },

  setDresses: function(dresses) {
    var event = $.extend({}, this.state.event);
    event.dresses = dresses;
    this.setState({event: event});
    this.refs.ChatMobileComp.forceUpdate();
    this.refs.ChatDesktop.forceUpdate();
  },

  handleLikeDress: function(dress) {
    var that = this,
        event = $.extend({}, that.state.event),
        method = dress.liked ? 'DELETE' : 'POST',
        url = this.props.event_path + '/dresses/' + dress.id + '/likes',
        dress = _.findWhere(event.dresses, {id: dress.id});

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

        that.refs.ChatDesktop.sendNotification({
          type: 'dress-like',
          dress: dress
        });

        that.setDresses(event.dresses);
      },
      error: function(data){
        // TODO add notification after is merged.
      }
    })
  },

  handleEventDetailUpdate: function(data){
    $.ajax({
      url: this.props.event_path,
      type: 'PUT',
      dataType: 'json',
      data: data,

      success: function(collection) {
        this.setState({event: collection.moodboard_event});
        var event = $.extend(event, this.state.event);
        event.hasError = {};
        this.setState({event: event});
        this.setState({event_backup: event});
      }.bind(this),

      error: function(data) {
        parsed = JSON.parse(data.responseText)
        var newEventState = $.extend(event, this.state.event_backup);
        var hasError = {};

        for(var key in parsed.errors) {
          hasError[key] = true;
          newEventState[key] = this.state.event_backup[key];
        };

        newEventState.hasError = hasError;
        this.setState({event: event});
      }.bind(this)
    });
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
      }.bind(this)
    })
  },

  sendDressToChatFn: function(dress) {
    this.refs.ChatDesktop.sendMessageTile(dress);
  },

  setDefaultTabWhenResize: function(){
    $(window).resize(function(e) {
      if (e.target.innerWidth >= 768 ) {
        var activeMobileChat = $(ReactDOM.findDOMNode(this.refs.chatMobile)).hasClass('active'),
            mobileSizeModal = $(this.refs.mobileSizeModal.refs.modal),
            activeMobileSizeModal = mobileSizeModal.is(':visible')
        if(activeMobileChat){
          $('.moodboard-tabs a[href="#bridesmaid-dresses"]').tab('show');
        }
        if(activeMobileSizeModal){
          mobileSizeModal.hide();
        }
      }
    }.bind(this));
  },

  changeDressToAddToCartCallback: function(dressId){
    var _state = $.extend({}, this.state);
    _state.dressToAddToCart = dressId;
    this.setState(_state);
  },

  updateUserCartCallback: function(cart) {
    var _state = $.extend({}, this.state);
    _state.userCart = cart;
    this.setState(_state);
  },

  render: function () {
    var chatProps = {
      twilio_token_path: this.props.twilio_token_path,
      event_id: this.props.event_id,
      bot_profile_photo: this.props.bot_profile_photo,
      profile_photo: this.props.profile_photo,
      username: this.props.username,
      user_id: this.props.user_id,
      filestack_key: this.props.filestack_key,
      getDresses: this.getDresses,
      setDresses: this.setDresses,
      handleLikeDress: this.handleLikeDress,
      twilioManager: this.state.twilioManager,
      twilioClient: this.state.twilioClient,
      changeDressToAddToCartCallback: this.changeDressToAddToCartCallback
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

    var addNewDressBigButton = <div className="add-dress-box"><a href={this.props.event_path + '/dresses/new'} className="add">Design a new dress</a></div>;
    var addNewDressSmallButton = <div className="dresses-actions text-center"><a href={this.props.event_path + '/dresses/new'} className="btn-transparent btn-create-a-dress"><em>Design</em> a new dress</a></div>;

    return (
      <div id="events__moodboard" className="row">
        <SizeGuideModal />
        <div className="mobile-select-size-modal">
          <SelectSizeModal {...selectSizeProps} ref="mobileSizeModal" position="center" />
        </div>
        <div className="left-content col-sm-5 hidden-xs">
          <SelectSizeModal {...selectSizeProps} position="left" />
          <Chat ref="ChatDesktop" {...chatProps}/>
        </div>
        <div className="right-content col-sm-7">
          <div className="right-container center-block">
            <SelectSizeModal {...selectSizeProps} position="right" />
            <h1 className="moodboard-title text-center">
               The Countdown: {this.state.event.remaining_days} days
            </h1>

            <div className="moodboard-tabs center-block">
              <div className="tabs-container">
                <ul className="nav nav-tabs center-block" role="tablist">
                  <li role="presentation" className="tab-chat hidden">
                    <a aria-controls="chat-mobile" data-toggle="tab" href="#chat-mobile" role="tab">
                      Chat  <span className="badge">12</span></a>
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
                  <Chat ref="ChatMobileComp" {...chatProps}/>
                </div>
                <div id="bridesmaid-dresses" className="tab-pane active center-block" role="tabpanel">
                  {this.state.event.dresses && this.state.event.dresses.length === 0 ? addNewDressBigButton: ''}
                  {this.state.event.dresses && this.state.event.dresses.length > 0 ? addNewDressSmallButton : ''}
                  <div className="dresses-list center-block">
                    <DressTiles dresses={this.state.event.dresses}
                      sendDressToChatFn={this.sendDressToChatFn}
                      removeDress={this.removeDress}
                      dressesPath={this.props.dresses_path}
                      handleLikeDress={this.handleLikeDress}
                      changeDressToAddToCartCallback={this.changeDressToAddToCartCallback}/>
                  </div>
                </div>
                <div id="wedding-details" className="tab-pane" role="tabpanel">
                  <EventDetails event={this.state.event}
                                updater={this.handleEventDetailUpdate}
                                roles_path={this.props.roles_path}
                                current_user={this.props.current_user.user}
                                hasError={this.state.event.hasError} />
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
    )
  }
});
