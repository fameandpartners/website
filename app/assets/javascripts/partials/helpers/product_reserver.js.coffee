window.helpers or= {}
window.helpers.initProductReserver = (elements, label, get_selected_color_func) ->

  _.each(elements, (element) ->
    productReserver = {
      element: $(element),
      label: label,
      get_selected_color_func: get_selected_color_func,

      onButtonClickHandler: (e) ->
        e.preventDefault()
        if productReserver.validate.call(productReserver)
          options = {
            productId:  $(e.target).data('id'),
            schoolName: $(e.target).data('school-name'),
            formalName: $(e.target).data('formal-name'),
            schoolYear: $(e.target).data('school-year'),
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

    $(element).on('click', productReserver.onButtonClickHandler)
  )

  return elements
