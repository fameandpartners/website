var ShoppingBag = React.createClass({
  propTypes: {
    checkoutUrl: React.PropTypes.string,
    cartItems: React.PropTypes.array
  },

  getInitialState: function () {
    return {
      userCart: {},
      show: false
    };
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
        if(!$backdrop.hasClass('animate')) {
          $(this).hide();
        }
      });
      $backdrop.removeClass('animate');
    }
  },

  fetchUserCart: function () {
    var that = this;
    $.ajax({
      url: '/wedding-atelier/orders',
      type: 'get',
      dataType: "json",
      success: function (data) {
        that.setState({
          userCart: data.order,
          show: true
        });
      },
      error: function (response) {
        ReactDOM.render(<Notification errors={['Oops! There was an error trying to load your shopping cart.']} />,
            document.getElementById('notification'));
      }
    });
  },

  bagOpenHandler: function () {
    this.fetchUserCart();
  },

  bagClosedHandler: function () {
    $(this.refs.backdrop).one('transitionend', function() {
      $(this).hide();
    });
    this.setState({show: false});
  },

  itemRemovedSuccessHandler: function (data, item) {
    this.fetchUserCart();
  },

  itemRemovedErrorHandler: function (response) {
    ReactDOM.render(<Notification errors={['Oops! There was an error trying to remove the item from the shopping cart.']} />,
        document.getElementById('notification'));
  },

  renderCartItems: function () {
    return (this.state.userCart.line_items || []).map(function (item, index) {
      var bagItemKey = 'shopping-bag-item-' + index;
      return (
        <ShoppingBagItem
          key={bagItemKey}
          item={item.line_item}
          itemRemovedSuccessHandler={this.itemRemovedSuccessHandler}
          itemRemovedErrorHandler={this.itemRemovedErrorHandler}/>
      );
    }.bind(this));
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
        <div className="commands-shopping-bag" onClick={this.bagOpenHandler}></div>
        <div className={backdropClasses} ref="backdrop"></div>
        <div className={windowClasses}>
          <div className="shopping-bag-header">
            <div className="shopping-bag-header-close">
              <img src="/assets/wedding-atelier/close.svg" onClick={this.bagClosedHandler}></img>
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
              <p>{this.state.userCart.display_shipment_total}</p>
              <p>{this.state.userCart.display_total}</p>
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
