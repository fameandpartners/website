
/*
 * Notification component.
 * Usage: You should render this component after a failure and attach it
 * to the #notification DOM node placed in the layout file.
 * Example:
 * React.render(<Notification errors={['error1', 'error2', 'error3']} />,
 *              document.getElementById('notification'));
 */

var Notification = React.createClass({
  propTypes: {
    errors: React.PropTypes.array
  },

  getInitialState: function () {
    return {
      show: false,
      timeOut: 8000
    };
  },

  componentWillMount: function () {
    this.setState({show: this.props.errors.length !== 0});
  },

  componentDidMount: function () {
    this.showAndHide();
  },

  componentDidUpdate: function () {
    this.showAndHide();
  },

  showAndHide: function () {
    if(this.state.show) {
      window.setTimeout(function () {
        this.setState({show: false});
      }.bind(this), this.state.timeOut);
    }
  },

  close: function () {
    this.setState({show: false});
  },

  renderErrors: function () {
    return this.props.errors.map(function (error, index) {
      return (
        <li key={'error-'+index} className="notification-message">
          <p>{error}</p>
        </li>
      );
    });
  },

  render: function () {
    var notificationClasses = classNames({
      'wedding-atelier-notification': true,
      'show': this.state.show
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
