var EventInvitations = React.createClass({
  getInitialState: function() {
    return { invitations: []}
  },

  componentDidMount: function() {
    this.setState({invitations: this.props.invitations});
  },

  handleSendInvite: function(e){
    var email = this.refs.email_address.value;
    $.ajax({
      url: this.props.send_invite_path,
      type: 'POST',
      dataType: 'json',
      data: {email_addresses: [email]},
      success: function(data) {
        data.invitations.map(function(invite) {
          this.state.invitations.push(invite);
          this.setState({invitations: this.state.invitations});
        }.bind(this))
      }.bind(this),
      error: function(error) {

      }
    })
    e.preventDefault();
  },

  handleRemoveBridesMaid: function(id){
    debugger;
    e.preventDefault();
  },

  render: function() {
    var assistants = this.props.assistants.map(function(assistant){
      var removeFromBoard = assistant.user.id == this.props.current_user_id ? '' : <span> | <a href="#" onClick={this.handleRemoveBridesMaid.bind(this, assistant.user.id)}>Remove from board</a></span>
      return (
        <div className="person">
          <div className="person-name">
            { assistant.user.first_name }
          </div>
          <div className="person-role">
            Bridesmaid
            {removeFromBoard}
          </div>
        </div>
      )
    }.bind(this))

    var invitations = this.state.invitations.map(function(invitation){
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
    }.bind(this))

    return(
      <form>
        <div className="form-group">
          <label for="input_email_address">Email address</label>
          <input type="email" className="form-control" placeholder="mail@mail.com" id="input_email_addres" ref="email_address"/>
        </div>
        <div className="text-center">
          <button className="btn-black" onClick={this.handleSendInvite}> Send invite</button>
        </div>
        <div className="invited-people">
          { assistants }
          { invitations }
        </div>
      </form>
    )
  }
});
