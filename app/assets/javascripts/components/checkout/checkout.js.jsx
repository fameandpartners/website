
var Checkout = React.createClass({
  render: function() {
    return (
        <div>
          <OrderSummary cart={this.props.cart}/>
        </div>
      );
  }
});

