var AddToCartButton = React.createClass({
  // We need sizeId separate since we can add to the cart this dress with custom dress size
  propTypes: {
    customizations: React.PropTypes.object,
    dress: React.PropTypes.object
  },
  handleAddToCart: function () {
    var dress = null;
    if(this.props.customizations.customized) {
      dress = this.props.customizations;
    } else {
      dress = this.props.dress;
    }

    var customization_ids = [dress.length.id, dress.fabric.id]
    if(dress.fit) {
      customization_ids.push(dress.fit.id)
    }
    if(dress.style) {
      customization_ids.push(dress.style.id)
    }

    var variantId = dress.product ? dress.product.variant_id : dress.silhouette.variant_id;
    var sizeId = dress.size.user_profile ? dress.size.user_profile.dress_size.id : dress.size.id;
    var attrs = {
      size_id: sizeId,
      color_id: dress.color.id,
      variant_id: variantId,
      height: dress.height_group || dress.heightGroup,
      customizations_ids: customization_ids
    };
    $.ajax({
      url: "/user_cart/products",
      type: "POST",
      dataType: "json",
      data: attrs,
      success: function (data) {
        var dressTitle = dress.title || dress.silhouette.name;
        ReactDOM.render(<Notification errors={[dressTitle + ' was added to your shopping cart!']} />,
                      document.getElementById('notification'));
      },
      error: function (response) {
        ReactDOM.render(<Notification errors={['Oops! There was an error adding your current customization to the shopping cart, try another combination.']} />,
            document.getElementById('notification'));
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
