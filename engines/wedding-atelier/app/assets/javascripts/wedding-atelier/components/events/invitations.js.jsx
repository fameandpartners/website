var EventInvitations = React.createClass({
  getInitialState: function() {
    return {}
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
          this.props.invitations.push(invite);
          this.setState({invitations: this.props.invitations});
        }.bind(this))
      }.bind(this),
      error: function(error) {

      }
    })
    e.preventDefault();
  },

  handleRemoveBridesMaid: function(id, index, e){
    this.props.handleRemoveAssistant(id, index);
    e.preventDefault();
  },

  render: function() {
    var assistants = this.props.assistants.map(function(assistant, index){
      var removeFromBoard = assistant.id == this.props.current_user_id ? '' : <span> | <a href="#" onClick={this.handleRemoveBridesMaid.bind(this, assistant.id, index)}>Remove from board</a></span>
      return (
        <div className="person" key={assistant.id}>
          <div className="person-name">
            { assistant.name }
          </div>
          <div className="person-role">
            {assistant.role}
            {removeFromBoard}
          </div>
        </div>
      )
    }.bind(this))

    var invitations = this.props.invitations.map(function(invitation, index){
      return (
        <div className="person" key={index + '-' + invitation.user_email}>
          <div className="person-name">
            { invitation.user_email }
          </div>
          <div className="person-role">
            { invitation.state }
          </div>
        </div>
      )
    }.bind(this))

    return(
      <form>
        <div className="form-group">
          <label htmlFor="input_email_address">Email address</label>
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
