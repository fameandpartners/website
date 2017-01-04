var MyAccount = React.createClass({
  propTypes: {
    user: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      activeTab: 0
    }
  },

  changeTab: function (tabIndex) {
    this.setState({activeTab: tabIndex});
  },

  render: function () {

    return (
      <div className="my-account-panel">
        <ul className="nav nav-tabs text-center" role="tablist">
          <li role="presentation" onClick={this.changeTab.bind(0)}>
            <a href="#" aria-controls="wiu" role="tab" data-toggle="tab">My Orders</a>
          </li>
          <li role="presentation" onClick={this.changeTab.bind(1)}>
            <a href="#" aria-controls="wiu" role="tab" data-toggle="tab">Account Details</a>
          </li>
          <li role="presentation" onClick={this.changeTab.bind(2)}>
            <a href="#" aria-controls="wiu" role="tab" data-toggle="tab">My Size Profile</a>
          </li>
        </ul>
        <div className="tab-content">
          <div id="my-orders" className="tab-pane"></div>
          <div id="account-details" className="tab-pane"></div>
          <div id="size-profile" className="tab-pane"></div>
        </div>
      </div>
    );
  }
});
