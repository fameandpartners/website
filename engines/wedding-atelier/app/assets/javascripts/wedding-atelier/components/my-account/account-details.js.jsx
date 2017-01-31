var AccountDetails = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired,
    account_path: React.PropTypes.string.isRequired
  },

  getInitialState: function () {
    var user = $.extend({}, this.props.user.user);
    return {
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      dateOfBirth: user.dob? moment(user.dob).format('MM/DD/YYYY') : null,
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
      newsletter: user.newsletter || false
    };
  },

  componentDidMount: function () {
    var options = {
      format: "mm/dd/yyyy",
      todayBtn: "linked",
      autoclose: true,
      showOnFocus: true,
      startView: 'years'
    };

    $(this.refs.dateOfBirth).datepicker(options).on('show', function(e){
      $(this).addClass('active');
    }).on('hide', function(e){
      $(this).removeClass('active');
    }).on('changeDate', this.dobChangedHandle);
  },

  dobChangedHandle: function (e) {
    this.setState({dateOfBirth: moment(e.date).format('MM/DD/YYYY')});
  },

  fieldChangedUpdate: function (field, e) {
    var newState = {};
    newState[field] = e.target.value;
    this.setState(newState);
  },

  newsletterChangedHandle: function (e) {
    this.setState({newsletter: !this.state.newsletter});
  },

  changesSavedHandle: function(e) {
    e.preventDefault();
    var state = this.state;
    var payload = {
      account: {
        first_name: state.firstName,
        last_name: state.lastName,
        email: state.email,
        dob: state.dateOfBirth? moment(state.dateOfBirth).format('DD/MM/YYYY') : null,
        newsletter: state.newsletter
      },
    };
    var notificationNode = document.getElementById('notification');
    if (this.allowedChangePassword()) {
      payload.account.current_password = state.currentPassword;
      payload.account.password = state.newPassword;
      payload.account.password_confirmation =  state.confirmPassword;
    }
    $.ajax({
      url: this.props.account_path,
      type: 'PUT',
      dataType: 'json',
      data: payload,
      success: function (response) {
        ReactDOM.unmountComponentAtNode(notificationNode);
        ReactDOM.render(<Notification errors={['Changes successfully saved']} />, notificationNode);
      },
      error: function (data) {
        ReactDOM.unmountComponentAtNode(notificationNode);
        ReactDOM.render(<Notification errors={JSON.parse(data.responseText).errors} />, notificationNode);
      }
    });
  },

  allowedChangePassword: function() {
    var state = $.extend({}, this.state);
    return state.currentPassword !== '';
  },

  render: function () {
    return (
      <div className="account-details">
        <form autoComplete={'off'} className="registrations__details-form">
          <div className="account-details-left col-xs-12 col-sm-6">
            <h1>Account details</h1>
            <div className="form-group">
              <label htmlFor="first-name">First name</label>
              <input type="text" id="first-name" name="first_name" className="form-control" value={this.state.firstName} onChange={this.fieldChangedUpdate.bind(null, 'firstName')}/>
            </div>
            <div className="form-group">
              <label htmlFor="last-name">Last name</label>
              <input type="text" id="last-name" name="last_name" className="form-control" value={this.state.lastName} onChange={this.fieldChangedUpdate.bind(null, 'lastName')}/>
            </div>
            <div className="form-group">
              <label htmlFor="email-address">Email address</label>
              <input type="email" id="email-address" name="email" className="form-control" value={this.state.email} onChange={this.fieldChangedUpdate.bind(null, 'email')}/>
            </div>
            <div className="form-group">
              <label htmlFor="date-of-birth">Date of birth</label>
              <div ref="dateOfBirth" className="input-group date date-picker">
                <input type="text" id="date-of-birth" name="date_of_birth" className="form-control wedding-date" value={this.state.dateOfBirth}/>
                  <div className="input-group-addon">
                    <i className="calendar-icon"></i>
                  </div>
              </div>
            </div>
          </div>

          <div className="account-details-right col-xs-12 col-sm-6">
            <h1><em>Update</em> Password</h1>
            <div className="form-group">
              <label htmlFor="current-password">Current password</label>
              <input type="password" id="current-password" name="current_password" className="form-control" value={this.state.currentPassword} onChange={this.fieldChangedUpdate.bind(null, 'currentPassword')}/>
            </div>
            <div className="form-group">
              <label htmlFor="new-password">New password</label>
              <input type="password" id="new-password" name="new_password" className="form-control" value={this.state.newPassword} onChange={this.fieldChangedUpdate.bind(null, 'newPassword')}/>
            </div>
            <div className="form-group">
              <label htmlFor="confirm-password">Confirm new password</label>
              <input type="password" id="confirm-password" name="confirm_password" className="form-control" value={this.state.confirmPassword} onChange={this.fieldChangedUpdate.bind(null, 'confirmPassword')}/>
            </div>
          </div>

          <div className="checkbox col-sm-12">
            <input refs="newsletter" type="checkbox" checked={this.state.newsletter}/>
            <label onClick={this.newsletterChangedHandle}>
              <span></span>
              <p className="text">Sign up to get the latest from Fame</p>
            </label>
          </div>

          <div className="col-sm-12 text-center">
            <button className="btn-black" onClick={this.changesSavedHandle}>Update</button>
          </div>
        </form>
      </div>
    );
  }
});
