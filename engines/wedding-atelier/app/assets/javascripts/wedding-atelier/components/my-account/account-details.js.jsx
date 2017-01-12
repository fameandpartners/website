var AccountDetails = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired
  },

  getInitialState: function () {
    var user = $.extend({}, this.props.user);
    return {
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
      dateOfBirth: user.dob
    };
  },

  componentDidMount: function () {
    var options = {
      format: "dd/mm/yyyy",
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

  firstNameChangedHandle: function (e) {
    this.setState({firstName: e.target.value});
  },

  lastNameChangedHandle: function (e) {
    this.setState({lastName: e.target.value});
  },

  emailChangedHandle: function (e) {
    this.setState({email: e.target.value});
  },

  dobChangedHandle: function (e) {
    this.setState({dateOfBirth: e.date.toLocaleDateString()});
  },

  render: function () {
    return (
      <div className="account-details">
        <form>
          <div className="form-group">
            <label htmlFor="first-name">First name</label>
            <input type="text" id="first-name" name="first_name" className="form-control" value={this.state.firstName} onChange={this.firstNameChangedHandle}/>
          </div>
          <div className="form-group">
            <label htmlFor="last-name">Last name</label>
            <input type="text" id="last-name" name="last_name" className="form-control" value={this.state.lastName} onChange={this.lastNameChangedHandle}/>
          </div>
          <div className="form-group">
            <label htmlFor="email-address">Email address</label>
            <input type="email" id="email-address" name="email" className="form-control" value={this.state.email} onChange={this.emailChangedHandle}/>
          </div>
          <div className="form-group">
            <label htmlFor="date-of-birth">Date of birth</label>
            <div ref="dateOfBirth" className="input-group date date-picker">
              <input type="text" id="date-of-birth" name="date_of_birth" className="form-control" value={this.state.dateOfBirth}/>
                <div className="input-group-addon">
                  <i className="calendar-icon"></i>
                </div>
            </div>
          </div>
        </form>
      </div>
    );
  }
});
