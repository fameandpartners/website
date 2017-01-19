var AddToCartButton = React.createClass({
  propTypes: {
    dress: React.PropTypes.object,
    sizeId: React.PropTypes.number
  },
  handleAddToCart: function () {
    dress = this.props.dress;
    size_id = this.props.sizeId || dress.size.id;
    customization_ids = [dress.length.id, dress.fabric.id]
    if(dress.fit) {
      customization_ids.push(dress.fit.id)
    }
    if(dress.style) {
      customization_ids.push(dress.style.id)
    }
    var attrs = {
      size_id: size_id,
      color_id: dress.color.id,
      variant_id: dress.product.variant_id,
      height: dress.height_group,
      customizations_ids: customization_ids
    };
    $.ajax({
      url: "/user_cart/products",
      type: "POST",
      dataType: "json",
      data: attrs,
      success: function (data) {
        //TODO: Show alert that the product has been added to the cart
      },
      error: function (response) {
        //TODO: Show errors
      }
    })
  },

  render: function(){
    var props = {
      className: 'btn-black',
      onClick: this.handleAddToCart
    };
    if(!this.props.dress){
      props.disabled = true;
    }
    return(
        <button {...props}>add to cart </button>
    )
  }
});
