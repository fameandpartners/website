#= require templates/shopping_cart_summary
window.ShoppingCartSummary = class ShoppingCartSummary
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_summary']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '#checkout')
    @$modalContainer = $('#top')
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
    # @$modalContainer.on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
    @$container.on('click', '.js-returns-learn-more', @openLearnMoreHandler)
    @cart.on('change', @render)
    @render()
    @

  customizationPrice: (displayPriceObj) ->
    currencySymbol = displayPriceObj.money.currency.html_entity
    displayTotal = parseInt(displayPriceObj.money.fractional, 10) / displayPriceObj.money.currency.subunit_to_unit
    currencySymbol + displayTotal

  isRegularSaleItem: (product) ->
    !product.message && product.name != 'RETURN_INSURANCE'

  shouldShowReturnOption: (products) ->
    products.some(@isRegularSaleItem)

  makingOptionDescriptionTag: (makingOptions) ->
    if (makingOptions[0].name.toLowerCase() == 'later')
      return '(' + makingOptions[0].display_discount + ')'
    else if (makingOptions[0].name.toLowerCase() == 'express')
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
      shouldShowReturnOption: @shouldShowReturnOption(@cart.data.products)
    ))

    console.log('Return Type: ' + @whichReturnType())
    if (@isPaymentStep() && @noReturnTypeSelected() && (@whichReturnType() != 'C'))
      @optInReminderModal()
    @showReturnCheckbox()
    @initializeReturnTypeCheckbox()
    @removeInsuranceIfInsuranceNotAllowed()

  isPaymentStep: () ->
    parser = document.createElement('a')
    parser.href = window.location.href
    pathArr = parser.pathname.split('/')
    paymentStep = pathArr.filter (i) -> i == 'payment'
    paymentStep.length > 0

  noReturnTypeSelected: () ->
    !@hasReturnInsurance()

  optInReminderModal: () ->
    if ( @containsNonSwatchItems() && !sessionStorage.getItem('returnModalShown'))
      new window.page.FlexibleReturnsModal(@whichReturnType())
      $(".ReturnModal").on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
      sessionStorage.setItem('returnModalShown', true)

  showReturnCheckbox: () ->
    classToShow = '.js-returns-abc-option-' + @whichReturnType()
    if (!$(classToShow).is(":visible"))
      $(classToShow).toggleClass('hidden')

  initializeReturnTypeCheckbox: () ->
    if (@hasReturnInsurance())
      $('.js-returns-trigger').prop('checked', true)
      $('.js-returns-abc-option-message').removeClass('hidden');

  containsNonSwatchItems: () ->
    lineItems = @cart.data.products.filter (i) -> i.swatch == false
    lineItems.length > 0

  findReturnInsuranceLineItem: () ->
    @cart.data.products.filter((p) -> return p.name == 'RETURN_INSURANCE')

  removeInsuranceIfInsuranceNotAllowed: () ->
    # If there is no longer a need to show Return's insurance, we need to make a DELETE
    # ... to remove the line item
    if (!@shouldShowReturnOption(@cart.data.products))
      returnInsuranceLineItem = @findReturnInsuranceLineItem()
      if (returnInsuranceLineItem && returnInsuranceLineItem[0])
        @cart.removeProduct(returnInsuranceLineItem[0].line_item_id)

  hasReturnInsurance: () ->
    returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
    returnInsurance.length

  whichReturnType: () ->
    $('#return_type').val()

  openLearnMoreHandler: (e) ->
    e.preventDefault()
    new window.page.FlexibleReturnsModal(e.currentTarget.id)
    @initializeReturnTypeCheckbox()

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

  addReturnType: () ->
    @cart.applyReturnTypePromoCode('DELIVERYINS')

  removeReturnType: (option) ->
    returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
    lineItemId = returnInsurance[0].line_item_id
    $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')
    $('.js-returns-abc-option-message').addClass('hidden');
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
