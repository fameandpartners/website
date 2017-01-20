var ShoppingBag = React.createClass({
  propTypes: {
    checkoutUrl: React.PropTypes.string,
    cartItems: React.PropTypes.array
  },

  getInitialState: function () {
    return {
      show: false
    };
  },

  componentWillMount: function () {
    var shoppingCart = new helpers.ShoppingCart({});
    var cart = shoppingCart.load();
  },

  componentWillUpdate: function (nextProps, nextState) {
    this.animateBackdrop(nextState.show);
  },

  animateBackdrop: function (fadeIn) {
    var $backdrop = $(this.refs.backdrop);
    if(fadeIn) {
      $backdrop.show(0, function () {
        $backdrop.addClass('animate');
      });
    } else {
      $backdrop.one('transitionend', function() {
        $(this).hide();
      });
      $backdrop.removeClass('animate');
    }
  },

  bagOpenHandle: function () {
    this.setState({show: true});
  },

  bagClosedHandle: function () {
    $(this.refs.backdrop).one('transitionend', function() {
      $(this).hide();
    });
    this.setState({show: false});
  },

  renderCartItems: function () {
    //TODO: Replace hard-coded array for cartItems prop

    return (this.props.cartItems || [1,2]).map(function (item, index) {
      return <ShoppingBagItem key={index} item={item} />
    });
  },

  render: function () {
    var windowClasses = classNames({
      'shopping-bag-window': true,
      'animate': this.state.show
    });

    var backdropClasses = classNames({
      'shopping-bag-backdrop': true,
      'hidden-xs': true
    });

    return (
      <div className="shopping-bag-container">
        <div className="commands-shopping-bag" onClick={this.bagOpenHandle}></div>
        <div className={backdropClasses} ref="backdrop"></div>
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
            <ul className="shopping-bag-content-list">
              {this.renderCartItems()}
            </ul>
          </div>
          <div className="shopping-bag-totals">
            <div className="shopping-bag-totals-labels">
              <p>shipping</p>
              <p>order total</p>
            </div>
            <div className="shopping-bag-totals-amounts">
              <p>Free shipping</p>
              <p>$598</p>
            </div>
          </div>
          <button className="shopping-bag-continue-payment btn-black">
            continue to payment
          </button>
        </div>
      </div>
    );
  }
});
