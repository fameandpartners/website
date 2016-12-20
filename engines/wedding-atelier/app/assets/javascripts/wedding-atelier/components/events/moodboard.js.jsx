var MoodBoardEvent = React.createClass({
  getInitialState: function (){
    return {event: {dresses: [], invitations: [], assistants: [], send_invite_path: '', current_user_id: '', name: 'Loading...'}}
  },

  componentDidMount: function (){
    $.ajax({
      url: this.props.event_path,
      type: "GET",
      dataType: 'json',
      success: function (data) {
        this.setState({event: data.moodboard_event});
      }.bind(this)
    });

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

        </div>
      </div>
    )
  }
});
