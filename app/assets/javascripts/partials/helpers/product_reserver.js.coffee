window.helpers or= {}
window.helpers.initProductReserver = (elements, label, get_selected_color_func) ->

  _.each(elements, (element) ->
    $element = $(element)

    productReserver = {
      element: $element,
      label: label,
      get_selected_color_func: get_selected_color_func,

      onButtonClickHandler: (e) ->
        e.preventDefault()
        if productReserver.validate.call(productReserver)
          link = $(e.target)
          options = {
            productId:  link.data('product-id'),
            schoolName: link.data('school_name'),
            formalName: link.data('formal_name'),
            schoolYear: link.data('school_year'),
            color: productReserver.get_selected_color_func(),
            label: productReserver.label
          }
          popup = new window.popups.ProductReservationPopup(options, productReserver.markReserved)
          popup.show()
          #popups.showProductReservationPopup(options, productReserver.markReserved)

      markReserved: (message) ->
        placeholder = $('<div>', {
          class: 'reserved',
          text: message or= "<i class='icon icon-tick-circle'></i> #{window.current_user.fullname}, you have reserved this dress"
        })
        productReserver.element.parent().replaceWith(placeholder)
        productReserver = null

      # 'private'
      validate: () ->
        if _.isEmpty(@get_selected_color_func())
          window.helpers.showErrors(@element.parent(), 'Please select a dress colour from above.')
          return false
        else
          return true
    }

    $element.on('click', productReserver.onButtonClickHandler)

    # update twin alerts buttons, bcz html will be cached...
    try
      if !_.isEmpty(window.bootstrap) && _.isArray(window.bootstrap.reservations) && window.bootstrap.reservations.length > 0
        product_id = $element.data('product-id')
        item = _.findWhere(window.bootstrap.reservations, { product_id: product_id })
        if _.isUndefined(item)
          item = window.bootstrap.reservations[0] || {}
          $element.data(_.extend(item, $element.data()))
        else
          #replace link with successful message
          $message = $element.parent().find('.reserved').show().removeClass('hide')
          $message.siblings().hide()
          $message.find('.username').html(window.current_user.first_name)
          $message.find('.color').html(item.color)
    catch error
      # do nothing, this is not critical
  )

  return elements
