var FeedbackButton = React.createClass({
  propTypes: {
    children: React.PropTypes.object,
    className: React.PropTypes.string,
    failureHandler: React.PropTypes.func,
    label: React.PropTypes.string,
    labelCompleted: React.PropTypes.string,
    promise: React.PropTypes.object,
    successHandler: React.PropTypes.func
  },

  getInitialState: function () {
    var props = $.extend({}, this.props);
    return {
      state: 'normal' // 1.Before load 2.Loading 3.Load finished
    };
  },

  componentDidUpdate: function (prevProps, prevState) {
    if (this.state.state === 'completed') {
      var that = this;
      window.setTimeout(function () {
        that.changeState('normal');
      }, 3000);
    }
  },

  clickHandlerWrapper: function (e) {
    var that = this;
    e.preventDefault();
    that.changeState('loading');
    this.props.promise().then(function(response) {
      that.props.successHandler(response);
      that.changeState('completed');
    }, function(xhrObj) {
      that.props.failureHandler(xhrObj);
      that.changeState('normal');
    });
  },

  changeState: function (next) {
    this.setState({state: next});
  },

  renderLabel: function () {
    switch (this.state.state) {
      case 'normal':
        return this.props.label;
      case 'loading':
        return <img src="/assets/wedding-atelier/loading.svg" />;
      case 'completed':
        return this.props.labelCompleted;
    }
  },

  render: function () {
    var style = 'feedback-button feedback-button-' + this.state.state;
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
