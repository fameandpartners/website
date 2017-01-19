var ShoppingBag = React.createClass({
  propTypes: {
    checkoutUrl: React.PropTypes.string
  },

  getInitialState: function () {
    return {
      show: false
    };
  },

  bagOpenHandle: function () {
    this.setState({show: true});
  },

  bagClosedHandle: function () {
    this.setState({show: false});
  },

  render: function () {
    var windowClasses = classNames({
      'shopping-bag-window': true,
      'animate': this.state.show
    });

    return (
      <div className="shopping-bag-container">
        <div className="commands-shopping-bag" onClick={this.bagOpenHandle}></div>
        <div className={windowClasses}>
          <div className="shopping-bag-header">
            <div className="shopping-bag-header-close">
              <img src="/assets/wedding-atelier/close.svg" onClick={this.bagClosedHandle}></img>
            </div>
            <div className="shopping-bag-header-title">
              <em>Your</em> cart
            </div>
            <div className="shopping-bag-header-checkout-link">
              <a href={this.props.checkoutUrl || '#'}>check out</a>
            </div>
          </div>
          <div className="shopping-bag-content">
            <p className="shopping-bag-content-statement">
              <span className="free-shipping">Free shipping</span> to the US, Canada, and the UK within 3-4 weeks. Easy exchanges within 30 days.
            </p>
          </div>
          <button className="shopping-bag-continue-payment btn-black">
            continue to payment
          </button>
        </div>
      </div>
    );
  }
});
