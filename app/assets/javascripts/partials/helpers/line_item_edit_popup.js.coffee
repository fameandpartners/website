window.helpers or= {}

window.helpers.createEditLineItemPopup = () ->
  popup = {
    currentItem: null
    container: null
    variantsSelector: null
    initialized: false

    # return hided placeholder
    init: () ->
      popup.container = $('.edit-line-item.modal').hide()
      popup.container.find('.close-lightbox').on('click', popup.cancelButtonClickHandler)
      popup.container.find('.save input.btn').on('click', popup.saveButtonClickHandler)

      return popup.container
  
    show: (itemId) ->
      popup.currentItem = itemId

      $.ajax("/line_items/#{itemId}/edit",
        type: 'GET',
        dataType: 'json',
        success: popup.showModalWindow
      )

    showModalWindow: (data) ->
      templateArgs = popup.prepareTemplateArgs(data)
      popup.container.show()
      item_html = JST['templates/line_item_edit_form'](templateArgs)
      popup.container.find('.item').replaceWith(item_html)
      popup.updateFormHandlers(data.variants, templateArgs.line_item.variant_id)
      popup.container.find('.value select.quantity-select').val(templateArgs.line_item.quantity)
      popup.container.center()

    prepareTemplateArgs: (response) ->
      return {
        line_item: response.line_item.line_item,
        sizes: window.getUniqueValues(response.variants, 'size')
        colors: window.getUniqueValues(response.variants, 'color')
        max_quantity: _.max([response.line_item.quantity + 5, 10])
      }

    updateFormHandlers: (variants, variantId) ->
      popup.variantsSelector = window.helpers.createProductVariantsSelector(popup.container)
      popup.variantsSelector.init(variants, { id: variantId })

    close: () ->
      popup.container.hide()

    cancelButtonClickHandler: (e) ->
      e.preventDefault()
      popup.close()

    saveButtonClickHandler: (e) ->
      e.preventDefault()
      formData = {
        variant_id: popup.variantsSelector.getSelectedVariant().id,
        quantity: $('.quantity-select').val()
      }
      window.shopping_cart.updateProduct(popup.currentItem, formData)
      popup.close()

    getFormDetails: () ->
  }

  return popup
