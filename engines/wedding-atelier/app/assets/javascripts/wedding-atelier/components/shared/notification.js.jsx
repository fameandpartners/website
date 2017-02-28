
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
    errors: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array
    ])
  },

  getInitialState: function () {
    return {
      show: false,
      timeOut: 8000
    };
  },

  componentWillMount: function () {
    this.setState({show: Array.isArray(this.props.errors) && this.props.errors.length > 0 || Object.keys(this.props.errors).length > 0});
  },

  componentDidMount: function () {
    this.showAndHide();
  },

  componentDidUpdate: function () {
    this.showAndHide();
  },

  showAndHide: function () {
    var show = Array.isArray(this.props.errors) && this.props.errors.length > 0 || Object.keys(this.props.errors).length > 0;
    if(this.state.show && show) {
      window.setTimeout(function () {
        if(this.isMounted()){
          this.setState({ show: false });
          this.delayedUnmount();
        }
      }.bind(this), this.state.timeOut);
    }
  },

  close: function () {
    if(this.isMounted()){
      this.setState({ show: false });
      this.delayedUnmount();
    }
  },

  renderErrors: function () {
    var that = this;
    var errorList;
    if(Array.isArray(that.props.errors) && that.props.errors.length > 0) {
      errorList = that.props.errors.map(function (error, index) {
        return (
          <li key={'error-'+index} className="notification-message">
            <p>{error}</p>
          </li>
        );
      });
    } else if (Object.keys(that.props.errors).length > 0) {
      errorList = [];
      Object.keys(that.props.errors).forEach(function (field) {
        var normalized = field.split(/_|\./).map(function (word, index) {
          return index === 0 ? word[0].toUpperCase() + word.slice(1) : word;
        }).join(' ');

        that.props.errors[field].forEach(function (error, index) {
          errorList.push(
            <li key={'error-' + field + '-' + index} className="notification-message">
              <p>{normalized + ' ' + error}</p>
            </li>
          );
        });
      });
    }
    return errorList;
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
