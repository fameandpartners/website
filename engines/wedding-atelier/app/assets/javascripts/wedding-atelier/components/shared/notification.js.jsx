
/*
 * Notification component.
 * Usage: You should render this component after a failure and attach it
 * to the #notification DOM node placed in the layout file.
 * Example:
 * React.render(<Notification notifications={['error1', 'error2', 'error3']} />,
 *              document.getElementById('notification'));
 */

var Notification = React.createClass({
  propTypes: {
    notifications: React.PropTypes.array
  },

  getInitialState: function () {
    return {
      notifications: [],
      show: false,
      timeOut: 8000
    };
  },

  componentDidMount: function(){
    if(this.props.notifications){
      this.notify(this.props.notifications);
    }
  },

  notify: function(notifications){
    this.setState({notifications: notifications, show: true});
    window.setTimeout(function () {
      this.setState({ show: false, notifications: [] });
    }.bind(this), this.state.timeOut);
  },

  close: function () {
    if(this.isMounted()){
      this.setState({ show: false, notifications: [] });
    }
  },

  renderErrors: function () {
    var that = this;
     var errorList;
     if(Array.isArray(that.state.notifications) && that.state.notifications.length > 0) {
       errorList = that.state.notifications.map(function (error, index) {
         return (
           <li key={'error-'+index} className="notification-message">
             <p>{error}</p>
           </li>
         );
       });
     } else if (Object.keys(that.state.notifications).length > 0) {
       errorList = [];
       Object.keys(that.state.notifications).forEach(function (field) {
         var normalized = field.split(/_|\./).map(function (word, index) {
           return index === 0 ? word[0].toUpperCase() + word.slice(1) : word;
         }).join(' ');

         that.state.notifications[field].forEach(function (error, index) {
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
