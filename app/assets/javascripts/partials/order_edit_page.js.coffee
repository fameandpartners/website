$(".orders.edit").ready ->
  window.shopping_cart.init(window.bootstrap)

  page = {
    isEmptyTemplate: JST['templates/cart_is_empty']
    container: null,
    editPopup: null,
    init: () ->
      window.shopping_cart.on('item_removed', page.removeItemFromList)
      window.shopping_cart.on('item_changed', page.updateItemInList)
      page.container = $('.wrap .cart-page').first()

      page.editPopup = window.helpers.createVariantsSelectorPopup()
      page.container.append(page.editPopup.init())

      page.updateHandlersFor(page.container)

    updateHandlersFor: (root_element) ->
      root_element.find('.remove-item-from-cart').on('click', page.removeItemClickHandler)
      root_element.find('.edit-link').on('click', page.editItemClickHandler)
      root_element.find('.wishlist a.move-to-wishlist').on('click', page.moveItemToWishlistClickHandler)

    removeItemClickHandler: (e) ->
      e.preventDefault()
      button = $(e.currentTarget)
      button.addClass('removing')
      window.shopping_cart.removeProduct(button.data('id'), {
        failure: () -> button.removeClass('removing')
      })

    editItemClickHandler: (e) ->
      e.preventDefault()
      line_item_id = $(e.currentTarget).data('id')
      variant_id   = $(e.currentTarget).data('variant')
      quantity    = $(e.currentTarget).data('quantity')
      page.editPopup.show({ variant_id: variant_id, quantity: quantity }, { id: line_item_id })
      page.editPopup.one('selected', (e, data) ->
        window.shopping_cart.updateProduct(data.params.id, data)
      )

    moveItemToWishlistClickHandler: (e) ->
      e.preventDefault()
      button = $(e.currentTarget)
      previousText = button.html()
      button.off('click').addClass('moving').html('moving...')
      window.shopping_cart.moveProductToWishlist(button.data('id'), {
        failure: () -> button.removeClass('moving').html(previousText).on('click', page.moveItemToWishlistClickHandler)
      })

    removeItemFromList: (e, data) ->
      if data.cart.line_items.length == 0
        page.container.find("li.item.grid-container[data-id='#{data.id}']").fadeOut('slow')
        page.container.find(".cart-labels").fadeOut 'slow', () ->
          page.container.find('ul.items, .cart-labels').remove()
          page.container.prepend(page.isEmptyTemplate()).hide().fadeIn('slow')
      else
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
