var MoodBoardEvent = React.createClass({

  propTypes: {
    event_path: React.PropTypes.string,
    remove_assistant_path: React.PropTypes.string,
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
        name: 'Loading...'
      }
    }
  },

  componentWillMount: function(){
    $.ajax({
      url: this.props.event_path,
      type: "GET",
      dataType: 'json',
      success: function (data) {
        this.setState({event: data.moodboard_event});
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
        $('.has-error').removeClass('has-error');
      }.bind(this),
      error: function(data) {
        parsed = JSON.parse(data.responseText)
        for(var key in parsed.errors) {
          $('input[name="' + key +'"').parent().addClass('has-error')
        };
      }
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
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});
