var MoodBoardEvent = React.createClass({

  propTypes: {
    event_path: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
    roles_path: React.PropTypes.string,
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
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
      var _state = $.extend({}, this.state);
      var manager = new Twilio.AccessManager(data.token);
      _state.twilioManager = manager;
      _state.twilioClient = new Twilio.IPMessaging.Client(manager);

      this.setState(_state);
    }.bind(this));
  },


  getDresses: function() {
    return this.state.event.dresses;
  },

  setDresses: function(dresses) {
    var event = $.extend({}, this.state.event);
    event.dresses = dresses;
    this.setState({event: event});
    this.refs.Chat.forceUpdate();
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
        that.refs.Chat.sendNotification({
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
    this.refs.Chat.sendMessageTile(dress);
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
      wedding_name: this.props.wedding_name,
      profile_photo: this.props.profile_photo,
      username: this.props.username,
      user_id: this.props.user_id,
      filestack_key: this.props.filestack_key,
      getDresses: this.getDresses,
      setDresses: this.setDresses,
      handleLikeDress: this.handleLikeDress,
      twilioManager: this.state.twilioManager,
      twilioClient: this.state.twilioClient
    }


    return (
      <div id="events__moodboard">
        <div className="chat left-content col-sm-6">
          <Chat ref="Chat" {...chatProps}/>
        </div>
        <div className="right-content col-sm-6">
          <div className='right-container'>
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
                  <a aria-controls="bridesmaid-dresses" data-toggle="tab" href="#bridesmaid-dresses" role="tab">
                    Bridesmaid dresses</a>
                </li>
                <li role="presentation">
                  <a aria-controls="wedding-details" data-toggle="tab" href="#wedding-details" role="tab">
                  Wedding details</a>
                </li>
                <li role="presentation">
                  <a aria-controls="manage-bridal-party" data-toggle="tab" href="#manage-bridal-party" role="tab">
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
                <div id="chat-mobile" className="tab-pane" role="tabpanel" ref="chatMobile">
                  <Chat ref="Chat" {...chatProps}/>
                </div>
                <div id="bridesmaid-dresses" className="tab-pane active center-block" role="tabpanel">
                  <div className="add-dress-box hidden">
                    <button className="add">Add your first dress</button>
                  </div>
                  <div className="dresses-actions text-center"><a href={this.props.event_path + '/dresses/new'} className="btn-transparent btn-create-a-dress">
                    <em>Create</em> a dress</a>
                  </div>
                  <div className="dresses-list center-block">
                    <DressTiles dresses={this.state.event.dresses}
                      sendDressToChatFn={this.sendDressToChatFn}
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
                    <em>Janine</em>, intive the bridal party.
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
