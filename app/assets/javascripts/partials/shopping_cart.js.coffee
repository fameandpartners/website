# it seems, we should disable this logic for admin part only.
$ ->
  window.shoppingCart = {
    updateProductListActions: () ->
      # enable carousel
      if $("#shopping-bag-popup").length > 0
        # items in cart carousel
        $("#shopping-bag-popup").carouFredSel({
          direction: "up", items: 2,
          circular: false, infinite: false, auto: false,
          prev: { button: "#shopping-arrow-up", key: "up", items: 2 }
          next: { button: "#shopping-arrow-down", key: "down", items: 2 }
        })
      # update remove action
      $('#shopping-bag-popup .remove-item-from-cart')
        .off('click')
        .on('click', shoppingCart.removeProductFromCartClicked)

    addProductButtonClicked: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('variant_id')
      shoppingCart.addProduct.call(shoppingCart, variantId)

    removeProductFromCartClicked: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      $(e.currentTarget).closest('li.item-block').fadeOut()
      shoppingCart.removeProduct.call(shoppingCart, variantId)

    addProduct: (variantId, callback) ->
      return unless variantId?

      $.ajax(
        url: "/line_items"
        type: 'POST'
        dataType: 'json'
        data: $.param({ variant_id: variantId, quantity: 1 })
        complete: (response) ->
          data = JSON.parse(response.responseText)
          $('#shopping-bag-popup-wrapper').replaceWith(data.cart_html)
          $('#shopping-bag-popup-wrapper').show()
          shoppingCart.updateProductListActions()
          window.items_in_cart.push(variantId)

          callback(data.order) if callback
      )

    removeProduct: (variantId, callback) ->
      return unless variantId?

      $.ajax(
        url: "/line_items/#{variantId}"
        type: 'DELETE'
        dataType: 'html'
        data: $.param({ variant_id: variantId })
        complete: (response) ->
          data = JSON.parse(response.responseText)
          $('#shopping-bag-popup-wrapper').replaceWith(data.cart_html)
          shoppingCart.updateProductListActions()
          window.items_in_cart = _.filter(window.items_in_cart, (variant_id) ->
            variant_id != variantId
          )
          if window.items_in_cart.length == 0
            $('#shopping-bag-popup-wrapper').hide()

          callback(data.order) if callback
      )
  }

  shoppingCart.updateProductListActions()

  # Toggle shopping bag in header
  $("#shopping-bag-popup-wrapper").hide()
  $(".shopping-bag-toggler").on "click", (e) ->
    e.preventDefault()
    $("#shopping-bag-popup-wrapper").slideToggle("slow")

  $('.buy-wishlist .buy-now').on('click', shoppingCart.addProductButtonClicked)
