var EventInvitations = React.createClass({
  getInitialState: function() {
    return { invitations: []}
  },

  componentDidMount: function() {
    this.setState({invitations: this.props.invitations});
  },

  handleUpdate: function(e) {
    $.ajax({
      url: this.props.update_path,
      type: 'PUT',
      dataType: 'json',
      data: {event: this.state.event},
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
    e.preventDefault();
  },

  _onChangeInput: function(e) {
    var _event = this.state.event;
    _event[e.target.name] = e.target.value;
    this.setState({event: _event})
  },

  render: function() {

    var assistants = this.props.assistants.map(function(assistant){
      return (
        <div className="person">
          <div className="person-name">
            { assistant.user.first_name }
          </div>
          <div className="person-role">
            Bridesmaid <span>| </span><a href="#">Remove from board</a>
          </div>
        </div>
      )
    })

    var invitations = this.props.invitations.map(function(invitation){
      return (
        <div className="person">
          <div className="person-name">
            { invitation.invitation.user_email }
          </div>
          <div className="person-role">
            { invitation.invitation.state }
          </div>
        </div>
      )
    })



    return(
      <form>
        <div className="form-group">
          <label for="input_email_address">Email address</label><input type="number" className="form-control" placeholder="mail@mail.com" id="input_email_addres"/>
        </div>
        <div className="text-center">
          <button className="btn-black" type="submit"> Send invite</button>
        </div>
        <div className="invited-people">
          { assistants }
          { invitations }
        </div>
      </form>
    )
  }
});
