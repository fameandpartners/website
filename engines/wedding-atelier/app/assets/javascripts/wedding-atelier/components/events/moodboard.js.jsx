var MoodBoardEvent = React.createClass({

  propTypes: {
    event_path: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
    roles_path: React.PropTypes.string,
    twilio_token_path: React.PropTypes.string,
    event_id: React.PropTypes.number,
    wedding_name: React.PropTypes.string,
    profile_photo: React.PropTypes.string,
    username: React.PropTypes.string
  },

  getInitialState: function (){
    return {
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
      }.bind(this)
    });
  },

  componentDidMount: function (){
    this.handleBrowserResizing();
  },

  handleBrowserResizing: function(){
    if (window.innerWidth <= 768) {
      $('.moodboard-tabs a[href="#chat-mobile"]').tab('show');
    }

    $(window).resize(function(e) {
      if (e.target.innerWidth > 768 ) {
        $('.moodboard-tabs a[href="#bridesmaid-dresses"]').tab('show');
      } else {
        $('.moodboard-tabs a[href="#chat-mobile"]').tab('show');
      }
    });
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

  render: function (){
    return (
      <div id="events__moodboard">
        <div className="chat left-content col-sm-6">
          <Chat twilio_token_path={this.props.twilio_token_path}
                event_id={this.props.event_id}
                wedding_name={this.props.wedding_name}
                profile_photo={this.props.profile_photo}
                username={this.props.username} />
        </div>
        <div className="right-content col-sm-6" id="atelier">
          <div className='right-container'>
            <h1 className="moodboard-title text-center">
              {this.state.event.name} - in {this.state.event.remaining_days} days
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
                  <a aria-controls="wedding-details" data-toggle="tab" href="#wedding-details" role="tab"> Wedding
                    details</a>
                </li>
                <li role="presentation">
                  <a aria-controls="manage-bridal-party" data-toggle="tab" href="#manage-bridal-party" role="tab"> Manage
                    bridal party</a>
                </li>
                <li role="presentation">
                  <a aria-controls="bridal-gowns" data-toggle="tab" href="#bridal-gowns" role="tab"> Bridal Gowns</a>
                </li>
              </ul>
              <div className="tab-content">
                <div id="chat-mobile" className="tab-pane" role="tabpanel">
                  <Chat twilio_token_path={this.props.twilio_token_path}
                    event_id={this.props.event_id}
                    wedding_name={this.props.wedding_name}
                    profile_photo={this.props.profile_photo}
                    username={this.props.username} />
                </div>
                <div id="bridesmaid-dresses" className="tab-pane active" role="tabpanel">
                  <div className="add-dress-box hidden">
                    <button className="add">Add your first dress</button>
                  </div>
                  <div className="dresses-actions text-center"><a href="#" className="btn-transparent btn-create-a-dress">
                    <em>Create</em> a dress</a>
                  </div>
                  <div className="dresses-list">
                    <DressTiles dresses={this.state.event.dresses} />
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
