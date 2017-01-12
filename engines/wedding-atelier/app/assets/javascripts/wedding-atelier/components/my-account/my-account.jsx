var MyAccount = React.createClass({
  propTypes: {
    user: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    sizeProfile: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      activeTab: 0
    };
  },

  changeTab: function (tabIndex) {
    this.setState({activeTab: tabIndex});
  },

  render: function () {

    return (
      <div className="my-account-panel">
        <ul className="nav nav-tabs text-center" role="tablist">
          <li role="presentation" onClick={this.changeTab.bind(this, 0)}>
            <a href="#my-orders" aria-controls="my-orders" role="tab" data-toggle="tab">My Orders</a>
          </li>
          <li role="presentation" onClick={this.changeTab.bind(this, 1)}>
            <a href="#account-details" aria-controls="account-details" role="tab" data-toggle="tab">Account Details</a>
          </li>
          <li className="active" role="presentation" onClick={this.changeTab.bind(this, 2)}>
            <a href="#size-profile" aria-controls="size-profile" role="tab" data-toggle="tab">My Size Profile</a>
          </li>
        </ul>
        <div className="tab-content">
          <div id="my-orders" className="tab-pane fade"></div>
          <div id="account-details" className="tab-pane fade">
            <AccountDetails
              user={this.props.user.user}/>
          </div>
          <div id="size-profile" className="tab-pane fade in active">
            <SizeProfile
              user={this.props.user.user}
              siteVersion={this.props.siteVersion}
              {...this.props.sizeProfile}/>
          </div>
        </div>
      </div>
    );
  }
});
