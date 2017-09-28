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
    console.log(@cart)
    console.log(@cart.data)

    @$container.html(@template(
      cart: @cart.data,
      customizationPrice: @customizationPrice,
      makingOptionDescriptionTag: @makingOptionDescriptionTag,
      makingOptionsDeliveryPeriod: @makingOptionsDeliveryPeriod,
      value_proposition: @value_proposition,
      shipping_message: @shipping_message
    ))

    @fakeOptimizely()
    console.log('return test: ' + @whichReturnType())
    @initializeReturnTypeCheckbox()

  initializeReturnTypeCheckbox: () ->
    # is there already a returnType in the cart?
    if (@hasReturnDiscount())
      console.log('In Cart: DISCOUNT')
      $('.js-returns-trigger-A').prop('checked', true)
      $('.js-returns-abc-option-message-A').toggleClass('hidden')
    else if (@hasReturnInsurance())
      console.log('In Cart: INSURANCE')
      $('.js-returns-trigger-B').prop('checked', true)
      $('.js-returns-abc-option-message-B').toggleClass('hidden')
    else
      console.log('No Return Type in Cart!')

  hasReturnInsurance: () ->
    returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
    returnInsurance.length

  hasReturnDiscount: () ->
    @cart.data.promocode == 'DELIVERYDISC'

  whichReturnType: () ->
    $('#return_type').val()

  fakeOptimizely: () ->
    # TO-DO: replicate in Optimizely
    # A == '10% Discount'
    # B == '$25 Insurance'

    returnTest = 'B'
    $('.js-returns-abc-option-' + returnTest).show()
    $('#return_type').val(returnTest)

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    @cart.removeProduct(line_item_id)

  returnsAbcHandler: (e) ->
    e.preventDefault()
    returnOption = e.currentTarget.value;

    if (e.currentTarget.checked)
      @addReturnType(returnOption)
    else
      @removeReturnType(returnOption)

  addReturnType: (option) ->
    if (option == 'A')
      console.log('Applying DISCOUNT...')
      @cart.applyReturnTypePromoCode('deliverydisc')
    else if (option == 'B')
      console.log('Applying INSURANCE...')
      @cart.applyReturnTypePromoCode('deliveryins')

  removeReturnType: (option) ->
    if (option == 'A')
      console.log('Removing DISCOUNT...')
      # { REMOVE DISCOUNT CODE }
    else if (option == 'B')
      console.log('Removing INSURANCE...')
      returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
      lineItemId = returnInsurance[0].line_item_id
      @cart.removeReturnTypeProduct(lineItemId)

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
