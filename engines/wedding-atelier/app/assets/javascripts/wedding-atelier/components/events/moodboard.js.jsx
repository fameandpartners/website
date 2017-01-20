var MoodBoardEvent = React.createClass({

  propTypes: {
    event_path: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
    dresses_path: React.PropTypes.string,
    roles_path: React.PropTypes.string,
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
    bot_profile_photo: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    username: React.PropTypes.string,
    user_id: React.PropTypes.number,
    filestack_key: React.PropTypes.string
  },

  getInitialState: function () {
    return {
      twilioManager: null,
      twilioClient: null,
      event: {
        dresses: [],
        invitations: [],
        assistants: [],
        send_invite_path: '',
        current_user_id: '',
        name: 'Loading...',
        hasError: {}
      },
      event_backup: {
        dresses: [],
        invitations: [],
        assistants: [],
        send_invite_path: '',
        current_user_id: '',
        name: 'Loading...',
        hasError: {}
      }
    }
  },

  componentWillMount: function(){
    $.ajax({
      url: this.props.event_path,
      type: "GET",
      dataType: 'json',
      success: function (data) {
        var event = $.extend(event, data.moodboard_event);
        var event_backup = $.extend(event_backup, data.moodboard_event);
        this.setState({event: event});
        this.setState({event_backup: event_backup});
        this.setDefaultTabWhenResize();
      }.bind(this)
    });

    $.post(this.props.twilio_token_path, function(data) {
      var that = this;
      var _state = $.extend({}, this.state);
      var manager = new Twilio.AccessManager(data.token);
      _state.twilioManager = manager;
      _state.twilioClient = new Twilio.IPMessaging.Client(manager);

      var channelName = 'wedding-atelier-channel-' + this.props.event_id;
      var notificationsChannelName = 'wedding-atelier-notifications-' + this.props.event_id;

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
                console.log('Joined channel as ' + that.props.username);

                that.refs.ChatDesktop.setUpMessagingEvents(channel);
                that.refs.ChatDesktop.sendMessageBot("Hey lovely, welcome to your amazing new weddings board. Here you're going to be able to chat with me, your bridesmaids and create some stunning bridal looks.")
                .then(function() {
                  return that.refs.ChatDesktop.sendMessageBot("Why don't you start by creating your first dress, just select 'Design a new dress' to the right.")
                  });
              });
          });
        }
      });

      this.setState(_state);
    }.bind(this));
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

        dresses[index] = parsedMsg.dress;
        that.setDresses(dresses);
      }
    });
  },

  getDresses: function() {
    return this.state.event.dresses;
  },

  removeDress: function(dress){
    var that = this,
        url = this.props.dresses_path + '/' + dress.id
    $.ajax({
      url: url ,
      type: 'DELETE',
      dataType: 'json',
      success: function(data) {
        var _newState = $.extend({}, that.state);
        _newState.event.dresses = _.reject(_newState.event.dresses, function(eventDress){
          return eventDress.id === data.event_dress.id;
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
        event = _extends({}, that.state.event),
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
          type: "dress-like",
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
        this.setState({event: collection.event});
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
      url: this.props.remove_assistant_path.replace('id', id),
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
      if (e.target.innerWidth > 768 ) {
        var activeMobileChat = $(ReactDOM.findDOMNode(this.refs.chatMobile)).hasClass('active');
        if(activeMobileChat){
          $('.moodboard-tabs a[href="#bridesmaid-dresses"]').tab('show');
        }
      }
    }.bind(this));
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
      twilioClient: this.state.twilioClient
    };

    var addNewDressBigButton = <div className="add-dress-box"><a href={this.props.event_path + '/dresses/new'} className="add">Design a new dress</a></div>;
    var addNewDressSmallButton = <div className="dresses-actions text-center"><a href={this.props.event_path + '/dresses/new'} className="btn-transparent btn-create-a-dress"><em>Design</em> a new dress</a></div>;

    return (
      <div id="events__moodboard" className="row">
        <div className="left-content col-sm-6 hidden-xs">
          <Chat ref="ChatDesktop" {...chatProps}/>
        </div>
        <div className="right-content col-sm-6">
          <div className='right-container center-block'>
            <h1 className="moodboard-title text-center">
              {this.state.event.name} - {this.state.event.remaining_days} days
            </h1>

            <div className="moodboard-tabs center-block">
              <ul className="nav nav-tabs center-block" role="tablist">
                <li role="presentation" className="tab-chat hidden">
                  <a aria-controls="chat-mobile" data-toggle="tab" href="#chat-mobile" role="tab">
                    Chat  <span className="badge">12</span></a>
                </li>
                <li className="active" role="presentation">
                  <a className="walkthrough-messages" aria-controls="bridesmaid-dresses" data-toggle="tab" href="#bridesmaid-dresses" role="tab" title="View your dresses" data-content="Create new looks and vote on your favorites" data-placement="bottom">
                    Bridesmaid dresses</a>
                </li>
                <li role="presentation">
                  <a className="walkthrough-messages" aria-controls="wedding-details" data-toggle="tab" href="#wedding-details" role="tab" title="Update the details" data-content="Input everything you need to know about the big day" data-placement="bottom">
                  Wedding details</a>
                </li>
                <li role="presentation">
                  <a className="walkthrough-messages" aria-controls="manage-bridal-party" data-toggle="tab" href="#manage-bridal-party" role="tab" title="Manage the group" data-content="Add, view, and remove members of the bridal party" data-placement="bottom">
                  Bridal party</a>
                </li>
                <li role="presentation" className="bridal-gowns">
                  <a aria-controls="bridal-gowns" href="#bridal-gowns" role="tab">
                    <span className="coming-soon">Coming Soon</span>
                    <span>Bridal Gowns</span>
                  </a>
                </li>
              </ul>
              <div className="tab-content">
                <div id="chat-mobile" className="tab-pane col-xs-12" ref="chatMobile" role="tabpanel">
                  <Chat ref="ChatMobileComp" {...chatProps}/>
                </div>
                <div id="bridesmaid-dresses" className="tab-pane active center-block" role="tabpanel">
                  {this.state.event.dresses.length === 0 ? addNewDressBigButton: ''}
                  {this.state.event.dresses.length > 0 ? addNewDressSmallButton : ''}
                  <div className="dresses-list center-block">
                    <DressTiles dresses={this.state.event.dresses}
                      sendDressToChatFn={this.sendDressToChatFn}
                      removeDress={this.removeDress}
                      dressesPath={this.props.dresses_path}
                      handleLikeDress={this.handleLikeDress} />
                  </div>
                </div>
                <div id="wedding-details" className="tab-pane" role="tabpanel">
                  <EventDetails event={this.state.event}
                                updater={this.handleEventDetailUpdate}
                                roles_path={this.props.roles_path}
                                hasError={this.state.event.hasError} />
                </div>
                <div id="manage-bridal-party" className="tab-pane center-block" role="tabpanel">
                  <h1 className="text-center">
                    <em>Now</em>, let's invite the bridal party.
                  </h1>
                  <EventInvitations invitations={this.state.event.invitations}
                                    assistants={this.state.event.assistants}
                                    handleRemoveAssistant={this.handleRemoveAssistant}
                                    send_invite_path={this.props.send_invite_path}
                                    curret_user_id={this.props.current_user_id} />
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
