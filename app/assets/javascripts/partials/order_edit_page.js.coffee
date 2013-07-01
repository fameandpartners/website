$(".orders.edit").ready ->
  window.shopping_cart.init(window.bootstrap)

  page = {
    container: null,
    init: () ->
      window.shopping_cart.on('item_removed', page.removeItemFromList)
      window.shopping_cart.on('item_changed', page.updateItemInList)
      page.container = $('.wrap .cart-page').first()

      page.container.find('.items .item.grid-container .remove-item-from-cart')
        .on('click', page.removeItemClickHandler)

    removeItemClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      window.shopping_cart.removeProduct(variantId)

    removeItemFromList: (e, data) ->
      console.log('removeItemFromList', arguments)
      page.container.find("li.item.grid-container[data-id='#{data.id}']").slideToggle('slow')
      page.updateOrderSummary.call(page, data.cart)

    updateItemsList: (e, data) ->
      console.log('updateItemsList', data)

    updateOrderSummary: (order) ->
      console.log(order)
      newSummaryHtml = JST['templates/order_summary'](order: order)
      page.container.find('.order-summary').first().replaceWith(newSummaryHtml)
  }

  page.init()
