#= require templates/shopping_cart_summary
window.ShoppingCartSummary = class ShoppingCartSummary
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_summary']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '#cart')
    @value_proposition = options.value_proposition
    @shipping_message = options.shipping_message

    _.bindAll(@,
      'customizationPrice',
      'makingOptionDescriptionTag',
      'render',
      'removeProductHandler',
      'removeProductCustomizationHandler',
      'removeProductMakingOptionHandler',
      'couponFormSubmitHandler',
      'returnsAbcHandler'
    )

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', '.customization-remove', @removeProductCustomizationHandler)
    @$container.on('click', '.making-option-remove', @removeProductMakingOptionHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)
    @$container.on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
    @cart.on('change', @render)
    @render()
    @

  customizationPrice: (displayPriceObj) ->
    currencySymbol = displayPriceObj.money.currency.html_entity
    displayTotal = parseInt(displayPriceObj.money.fractional, 10) / displayPriceObj.money.currency.subunit_to_unit
    currencySymbol + displayTotal

  makingOptionDescriptionTag: (makingOptions) ->
    if (makingOptions[0].name.toLowerCase() == 'deliver later')
      return '(' + makingOptions[0].display_discount + ')'
    else if (makingOptions[0].name.toLowerCase() == 'deliver express')
      return '(+' + makingOptions[0].display_discount + ')'

  makingOptionsDeliveryPeriod: (makingOptions, deliveryPeriod) ->
    if (makingOptions[0])
      return makingOptions[0].delivery_period

    deliveryPeriod

  render: () ->
    @$container.html(@template(
      cart: @cart.data,
      customizationPrice: @customizationPrice,
      makingOptionDescriptionTag: @makingOptionDescriptionTag,
      makingOptionsDeliveryPeriod: @makingOptionsDeliveryPeriod,
      value_proposition: @value_proposition,
      shipping_message: @shipping_message
    ))

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    @cart.removeProduct(line_item_id)

  returnsAbcHandler: (e) ->
    e.preventDefault()
    targetMessageClass = '.js-returns-abc-option-message-' + e.currentTarget.value;
    $(targetMessageClass).toggleClass('hidden')

  removeProductCustomizationHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    customization_id = $(e.currentTarget).data('id')
    @cart.removeProductCustomization(line_item_id, customization_id)

  removeProductMakingOptionHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    making_option_id = $(e.currentTarget).data('id')
    @cart.removeProductMakingOption(line_item_id, making_option_id)

  couponFormSubmitHandler: (e) ->
    e.preventDefault() if e
    $input = $('form .promo-code-value:visible')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())
