var AddToCartButton = React.createClass({
  // We need sizeId separate since we can add to the cart this dress with custom dress size
  propTypes: {
    customizations: React.PropTypes.object,
    dress: React.PropTypes.object,
    sizeId: React.PropTypes.number
  },
  handleAddToCart: function () {
    var dress = null;
    if(this.props.customizations.customized) {
      dress = this.props.customizations;
    } else {
      dress = this.props.dress;
    }

    var size_id = this.props.sizeId || dress.size.id;
    var customization_ids = [dress.length.id, dress.fabric.id]
    if(dress.fit) {
      customization_ids.push(dress.fit.id)
    }
    if(dress.style) {
      customization_ids.push(dress.style.id)
    }

    var variant_id = dress.product ? dress.product.variant_id : dress.silhouette.variant_id;
    var attrs = {
      size_id: size_id,
      color_id: dress.color.id,
      variant_id: variant_id,
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
    return(
        <button {...props}>add to cart </button>
    )
  }
});
