$(".orders.edit").ready ->
  window.shopping_cart.init(window.bootstrap)

  page = {
    container: null,
    editPopup: null,
    init: () ->
      window.shopping_cart.on('item_removed', page.removeItemFromList)
      window.shopping_cart.on('item_changed', page.updateItemInList)
      page.container = $('.wrap .cart-page').first()

      page.editPopup = window.helpers.createEditLineItemPopup()
      page.container.append(page.editPopup.init())

      page.updateHandlersFor(page.container)

    updateHandlersFor: (root_element) ->
      root_element.find('.remove-item-from-cart').on('click', page.removeItemClickHandler)
      root_element.find('.edit-link').on('click', page.editItemClickHandler)

    removeItemClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      window.shopping_cart.removeProduct(variantId)

    editItemClickHandler: (e) ->
      e.preventDefault()
      itemId    = $(e.currentTarget).data('id')
      page.editPopup.show(itemId)

    removeItemFromList: (e, data) ->
      page.container.find("li.item.grid-container[data-id='#{data.id}']").slideToggle('slow')
      page.updateOrderSummary.call(page, data.cart)

    # data.id = line_item_id
    # data.cart.line_items - new items, we receive new variant id
    # to remove, we should find old variant/line_item
    updateItemInList: (e, data) ->
      itemId = data.id
      line_item = _.find(data.cart.line_items, (item) -> item.id == itemId)
      line_item_html = JST['templates/line_item'](order: data.cart, line_item: line_item)

      row_selector = "li.item.grid-container[data-line-item-id='#{line_item.id}']"
      page.container.find(row_selector).replaceWith(line_item_html)
      page.updateHandlersFor(page.container.find(row_selector))

      page.updateOrderSummary.call(page, data.cart)

    updateOrderSummary: (order) ->
      newSummaryHtml = JST['templates/order_summary'](order: order)
      page.container.find('.order-summary').first().replaceWith(newSummaryHtml)
  }

  page.init()
