var UserFields = React.createClass({
  nextStep: function(e) {
    e.preventDefault();

    var data = {
      first_name: this.refs.user_first_name.value,
      last_name: this.refs.user_last_name.value,
      email: this.refs.user_email.value,
      password: this.refs.user_password.value,
      wedding_atelier_signup_step: 'tutorial',

      user_profile_attributes: {
        trend_updates: this.refs.profile_trend_updates.value
      }
    }

    this.props.saveValues(data);
    this.props.submitRegistration();
  },

  render: function() {
    return (
      <div className="registrations__new-form left-side-centered-container">
        <h1 className="text-center">
          One last thing.
        </h1>
        <div className="form">

          <label>First name</label>
          <input className="form-control" id="spree_user_first_name" ref="user_first_name" />

          <label>Last name</label>
          <input className="form-control" id="spree_user_last_name" ref="user_last_name" />

          <label>Email Address</label>
          <input className="form-control" id="spree_user_email" ref="user_email" type="email" />

          <label>Password</label>
          <input className="form-control" id="spree_user_password" ref="user_password" type="password" />

          <div className="checkbox">
            <input ref="profile_trend_updates" type="checkbox" value="1" />
            <label htmlFor="spree_user_user_profile_attributes_trend_updates">
              Sign up to get the latest from Fame
            </label>
          </div>
      </div>
      <input className="btn btn-black full-width" name="commit" defaultValue="next" onClick={this.nextStep} />

      </div>
    );
  }
});


