var Notification = React.createClass({
  propTypes: {
    errors: React.PropTypes.array
  },

  getInitialState: function () {
    return {
      errors: []
    };
  },

  componentWillReceiveProps: function () {
    if (this.state.errors.length === 0) {
      this.setState({errors: this.props.errors});
    }
  },

  close: function () {
    this.setState({errors: []});
  },

  renderErrors: function () {
    return this.state.errors.map(function (error, index) {
      <li className="notification-message">
        <p>{error}</p>
      </li>
    });
  },

  render: function () {
    var notificationClasses = classNames({
      'wedding-atelier-notification': true,
      'hidden': this.state.errors.length === 0
    });

    return (
      <div className={notificationClasses}>
        <ul className="notification-list">
          {this.renderErrors()}
        </ul>
        <div className="notification-close" onClick={this.close}>x</div>
      </div>
    );
  }
});
