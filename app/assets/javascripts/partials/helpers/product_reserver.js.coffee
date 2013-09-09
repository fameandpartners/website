window.helpers or= {}
window.helpers.initProductReserver = (elements, label, variantsSelector) ->

  _.each(elements, (element) ->
    productReserver = {
      selector: variantsSelector,
      element: $(element),
      label: label,

      onButtonClickHandler: (e) ->
        e.preventDefault()
        if productReserver.validate.call(productReserver)
          options = {
            productId:  $(e.target).data('id'),
            schoolName: $(e.target).data('school-name'),
            formalName: $(e.target).data('formal-name'),
            schoolYear: $(e.target).data('school-year'),
            color: productReserver.selectedColor(),
            label: productReserver.label
          }
          popups.showProductReservationPopup(options, productReserver.remove)

      remove: () ->
        productReserver.element.hide()
        productReserver = null

      # 'private'
      validate: () ->
        result = true
        color = @selectedColor()
        if _.isEmpty(color)
          result = false
          @showErrorMessage('Please, select dress colour')
        return result

      selectedColor: () ->
        return null if _.isEmpty(@selector.selected)
        color = @selector.selected.color
        return null if _.isEmpty(color)
        return color

      showErrorMessage: (messageText) ->
        container = @element.parent()
        block = container.find('.error.message')
        if block.length == 0
          container.append($("<span class='error message' style='display: none;'></span>"))
          block = container.find('.error.message')
        block.text(messageText).fadeIn()

        setTimeout(productReserver.hideErrorMessage, 3000)
        # i know, this should be separate event bus line...
        @selector.container.find(".colors-choser .colors .color").
          one('click', productReserver.hideErrorMessage)

      hideErrorMessage: () ->
        productReserver.element.parent().find('.error.message').fadeOut()
    }

    $(element).on('click', productReserver.onButtonClickHandler)
  )

  return elements
