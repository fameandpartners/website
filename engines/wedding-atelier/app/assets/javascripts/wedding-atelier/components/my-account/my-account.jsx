var MyAccount = React.createClass({
  propTypes: {
    user: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    sizeProfile: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      activeTab: 1
    };
  },

  changeTab: function (tabIndex) {
    this.setState({activeTab: tabIndex});
  },

  render: function () {

    return (
    <div></div>
    );
  }
});
