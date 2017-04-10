var EventInvitations = React.createClass({
  propTypes: {
    assistants: React.PropTypes.array,
    initialInvitations: React.PropTypes.array,
    send_invite_path: React.PropTypes.string.isRequired,
    handleRemoveAssistant: React.PropTypes.func,
    current_user_id: React.PropTypes.number,
    event_owner_id: React.PropTypes.number.isRequired
  },

  getInitialState: function() {
    return {
      invitations: [],
      notifications: []
    };
  },

  componentWillReceiveProps(nextProps) {
    var nextState = $.extend({}, this.state);

    nextState.current_owner_id = nextProps.current_user_id;

    if (this.state.invitations.length === 0 && nextProps.initialInvitations.length > 0) {
      nextState.invitations = nextProps.initialInvitations.slice();
    }

    this.setState(nextState);
  },

  handleSendInvite: function(e){
    var that = this,
        emailField = that.refs.email_address,
        email = emailField.value;
    e.preventDefault();
    if(!emailField.checkValidity()) {
      this.refs.notifications.notify(["Invalid email format."]);
      return false;
    }

    if(!email){
      this.refs.notifications.notify(["Email field can\'t be blank"]);
      return false;
    }

    $.ajax({
      url: that.props.send_invite_path,
      type: 'POST',
      dataType: 'json',
      data: {email_addresses: [email]},
      success: function(data) {
        emailField.value = '';
        that.setState({invitations: data.invitations});
        that.refs.notifications.notify(['Invite successfully sent to ' + email + '.'])
      },
      error: function(error) {
        that.refs.notifications.notify(["Sorry, we could not send the invitation to " + email + '.']);
      }
    });
  },

  handleRemoveBridesMaid: function(id, index, e){
    this.props.handleRemoveAssistant(id, index);
    e.preventDefault();
  },

  renderAssistants: function () {
    var that = this;
    return this.props.assistants.map(function(assistant, index) {
      var removeFromBoard;
      if(assistant.id != that.props.event_owner_id){
        removeFromBoard = <span> | <a href="#" onClick={that.handleRemoveBridesMaid.bind(that, assistant.id, index)}>Remove from board</a></span>;
      }

      return (
        <div className="person" key={assistant.id}>
          <div className="person-name">
            {assistant.name}
          </div>
          <div className="person-role">
            {assistant.role}
            {removeFromBoard}
          </div>
        </div>
      );
    });
  },

  renderInvitations: function () {
    return this.state.invitations.map(function(invitation, index){
      return (
        <div className="person" key={invitation.id}>
          <div className="person-name">
            {invitation.user_email}
          </div>
          <div className="person-role">
            {invitation.state}
          </div>
        </div>
      );
    });
  },

  render: function() {
    return(
      <form>
        <Notification ref='notifications'/>
        <div className="form-group">
          <label htmlFor="input_email_address">Email address</label>
          <input type="email" className="form-control" placeholder="mail@mail.com" id="input_email_addres" ref="email_address"/>
        </div>
        <div className="text-center">
          <button className="btn-black" onClick={this.handleSendInvite}> Send invite</button>
        </div>
        <div className="invited-people">
          {this.renderAssistants()}
          {this.renderInvitations()}
        </div>
      </form>
    );
  }
});
