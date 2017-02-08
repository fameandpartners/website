var FeedbackButton = React.createClass({
  propTypes: {
    children: React.PropTypes.object,
    className: React.PropTypes.string,
    failureHandler: React.PropTypes.func,
    label: React.PropTypes.string,
    options: React.PropTypes.object,
    successHandler: React.PropTypes.func
  },

  clickHandlerWrapper: function (e) {
    var that = this;
    e.preventDefault();
    debugger;
    var promise = Promise.resolve($.ajax(this.props.options));
    promise.then(function(response) {
      that.props.successHandler(response);
    }, function(xhrObj) {
      that.props.failureHandler(xhrObj);
    });
  },

  render: function () {
    return (
      <button
        className={this.props.className}
        onClick={this.clickHandlerWrapper}>
        {this.props.label}
      </button>
    );
  }
});
