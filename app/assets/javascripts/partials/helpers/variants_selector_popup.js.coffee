window.helpers or= {}

window.helpers.createVariantsSelectorPopup = () ->
  popup = {
    eventBus: $({})
    eventParams: {}
    params: {}
    container: null
    variantsSelector: null
    initialized: false
    current_site: window.current_site_version.permalink

    init: () ->
      if !popup.initialized
        popup.container = window.popups.getModalContainer('Edit product details', 'Save changes')
        popup.content = popup.container.find('.modal-container')
        popup.container.find('.close-lightbox').on('click', popup.cancelButtonClickHandler)
        popup.container.find('.save input.btn').on('click', popup.saveButtonClickHandler)
        popup.container.find('.overlay').on('click', popup.cancelButtonClickHandler)
        popup.initialized = true

      return popup
  
    # options should contains one of id, product_id, variant_id
    show: (params = {}, eventParams = {}) ->
      popup.params = params
      popup.eventParams = eventParams

      $.ajax(
        url: urlWithSitePrefix('/product_variants'),
        type: 'GET',
        dataType: 'json',
        data: params
        success: popup.showModalWindow
      )

    showModalWindow: (data) ->
      templateArgs = popup.prepareTemplateArgs(data)
      popup.container.show()

      item_html = JST['templates/variants_selector_form'](templateArgs)
      popup.container.find('.item').html(item_html)

      preselectedVariant = popup.params.variant_id
      preselectedVariant = data.variants[0].id unless preselectedVariant?
      popup.updateFormHandlers(data.variants, preselectedVariant)

      quantity = popup.params.quantity
      quantity = 1 unless quantity?
      popup.container.find('.value select.quantity-select').val(quantity)
      popup.content.center()
      popup

    prepareTemplateArgs: (response) ->
      result = {
        product: response.product.product,
        sizes: popup.getSizes(response.variants),
        colors: popup.getColorsMap(response.variants)
        max_quantity: 10
      }
      if popup.params.quantity
        result.quantity = popup.params.quantity
      else
        result.quantity = 1
      result

    updateFormHandlers: (variants, variantId) ->
      popup.container.find('.selectbox').chosen({width: '100%', disable_search: true })
      popup.variantsSelector = window.helpers.createProductVariantsSelector(popup.container)
      popup.variantsSelector.target = popup.container.find('.submit input.btn')
      popup.variantsSelector.init(variants, { id: variantId })

    close: () ->
      # clear current state
      popup.params = {}
      popup.eventParams = {}
      # close popup
      popup.container.hide()

    cancelButtonClickHandler: (e) ->
      e.preventDefault()
      popup.close()

    saveButtonClickHandler: (e) ->
      e.preventDefault()
      formData = {
        variant_id: popup.variantsSelector.target.data('id')
        quantity: $('.quantity-select').val()
        params: popup.eventParams
      }
      if formData.variant_id?
        popup.trigger('selected', formData)
        popup.close()
      else
        error_message = $(e.target).data('error')
        error_message = 'Please, select size and color' if _.isEmpty(error_message)
        window.helpers.showErrors(popup.container, error_message)

    getColorsMap: (variants) ->
      map = {}
      _.each(variants, (variant) ->
        map[variant.color] = variant.color_code
      )
      map

    getSizes: (response) ->
      if popup.current_site == "au"
        sizes = window.getUniqueValues(response, 'size')
        sorted = sizes.sort (a, b) -> a - b
        sorted[2..10]
      else
        window.getUniqueValues(response, 'size').sort (a, b) -> a - b  
  }

  popup.on      = delegateTo(popup.eventBus, 'on')
  popup.one     = delegateTo(popup.eventBus, 'one')
  popup.off     = delegateTo(popup.eventBus, 'off')
  popup.trigger = delegateTo(popup.eventBus, 'trigger')

  popup.init()

  return popup
