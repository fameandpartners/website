window.helpers or= {}

window.helpers.addCustomizationButtonHandlers = (customizationButton) ->
  $button = $(customizationButton)

  $button.off('click')
  $button.off('variant_selected')

  # add product to cart
  $button.on('click', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    button = $(e.currentTarget)

    variantId = button.siblings('.buy-now').data('id')

    if variantId?
      productPersonalizationPopup.show({variant_id: variantId})
    else
      window.helpers.showErrors($(e.currentTarget).parent(), 'Please, select size and colour')
  )

  $button.on('variant_selected', (e) ->
    window.helpers.hideErrors($(e.currentTarget).parent())
  )
