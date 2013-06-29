$(".orders.edit").ready ->
  # main difference from window.shoppingCart
  # - we can't add items on this page
  # and no needed to reupdate with ajax.
  # but we still need updates with
  
  orderEditor = {
    onRemoveClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      orderEditor.removeProduct.call(orderEditor, variantId)

    removeProduct: (variantId) ->
      onSuccessCallback = ->
        $(".items .item.grid-container[data-id=#{variantId}]").fadeOut()
      window.shoppingCart.removeProduct.call(window.shoppingCart, variantId, onSuccessCallback)
  }
    
  $('.items .item.grid-container .remove-item-from-cart').on('click', orderEditor.onRemoveClickHandler)
