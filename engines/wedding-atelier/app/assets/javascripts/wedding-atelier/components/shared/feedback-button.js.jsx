var FeedbackButton = React.createClass({
  propTypes: {
    children: React.PropTypes.object,
    className: React.PropTypes.string,
    failureHandler: React.PropTypes.func,
    label: React.PropTypes.string,
    labelCompleted: React.PropTypes.string,
    options: React.PropTypes.object,
    successHandler: React.PropTypes.func
  },

  getInitialState: function () {
    var props = $.extend({}, this.props);
    return {
      state: 1 // 1.Before load 2.Loading 3.Load finished
    };
  },

  componentDidUpdate: function (prevProps, prevState) {
    if (this.state.state === 3) {
      var that = this;
      window.setTimeout(function () {
        that.changeState(1);
      }, 3000);
    }
  },

  clickHandlerWrapper: function (e) {
    var that = this;
    e.preventDefault();
    that.changeState(2);
    var promise = Promise.resolve($.ajax(this.props.options));
    promise.then(function(response) {
      that.props.successHandler(response);
      that.changeState(3);
    }, function(xhrObj) {
      that.props.failureHandler(xhrObj);
      that.changeState(1);
    });
  },

  changeState: function (next) {
    this.setState({state: next});
  },

  renderLabel: function () {
    switch (this.state.state) {
      case 1:
        return this.props.label;
      case 2:
        return <img src="/assets/wedding-atelier/loading.svg"/>;
      case 3:
        return this.props.labelCompleted;
    }
  },

  render: function () {
    var style = 'feedback-button-' + this.state.state;
    var classes = this.props.className + ' ' + style;
    return (
      <button
        className={classes}
        onClick={this.clickHandlerWrapper}>
        {this.renderLabel()}
      </button>
    );
  }
});
