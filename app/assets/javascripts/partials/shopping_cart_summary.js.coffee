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
      'returnsAbcHandler',
      'openLearnMoreHandler'
    )

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', '.customization-remove', @removeProductCustomizationHandler)
    @$container.on('click', '.making-option-remove', @removeProductMakingOptionHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)
    @$container.on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
    @$container.on('click', '.js-returns-learn-more', @openLearnMoreHandler)
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
    if (@isPaymentStep() && @noReturnTypeSelected() && (@whichReturnType() != 'C'))
      @optInReminderModal()
    @initializeReturnTypeCheckbox()

  isPaymentStep: () ->
    parser = document.createElement('a')
    parser.href = window.location.href
    pathArr = parser.pathname.split('/')
    paymentStep = pathArr.filter (i) -> i == 'payment'
    paymentStep.length > 0

  noReturnTypeSelected: () ->
    !@hasReturnDiscount() && !@hasReturnInsurance()

  optInReminderModal: () ->
    if (!sessionStorage.getItem('returnModalShown'))
      new window.page.ReturnsOptimizelyModal(@whichReturnType())
      $(".ReturnModal").on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
      sessionStorage.setItem('returnModalShown', true)

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

    returnTest = 'A'
    $('.js-returns-abc-option-' + returnTest).toggleClass('hidden')
    $('#return_type').val(returnTest)

  openLearnMoreHandler: (e) ->
    e.preventDefault()
    console.log(e)
    new window.page.ReturnsOptimizelyModal(e.currentTarget.id)
    $('.vex-dialog-button-primary').hide()

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
      @cart.applyReturnTypePromoCode('DELIVERYDISC')
    else if (option == 'B')
      console.log('Applying INSURANCE...')
      @cart.applyReturnTypePromoCode('DELIVERYINS')

  removeReturnType: (option) ->
    if (option == 'A')
      console.log('Removing DISCOUNT...')
      @cart.applyReturnTypePromoCode('DELIVERYDISC')
    else if (option == 'B')
      console.log('Removing INSURANCE...')
      returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
      lineItemId = returnInsurance[0].line_item_id
      $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')
      @cart.removeProduct(lineItemId)

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
