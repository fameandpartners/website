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
      'render',
      'removeProductHandler',
      'couponFormSubmitHandler',
      'returnsAbcHandler',
    )

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)
    @$container.on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
    # @$modalContainer.on('change', '.js-returns-abc-option-trigger', @returnsAbcHandler)
    @cart.on('change', @render)
    @render()
    @

  isRegularSaleItem: (product) ->
    !product.message && product.name != 'RETURN_INSURANCE'

  render: () ->
    @$container.html(@template(
      cart: @cart.data,
      value_proposition: @value_proposition,
      shipping_message: @shipping_message
    ))

    console.log('Return Type: ' + @whichReturnType())

    @showReturnCheckbox()
    @initializeReturnTypeCheckbox()

  isPaymentStep: () ->
    parser = document.createElement('a')
    parser.href = window.location.href
    pathArr = parser.pathname.split('/')
    paymentStep = pathArr.filter (i) -> i == 'payment'
    paymentStep.length > 0

  noReturnTypeSelected: () ->
    !@hasReturnInsurance()

  optInReminderModal: () ->
    if (!sessionStorage.getItem('returnModalShown'))
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

  findReturnInsuranceLineItem: () ->
    @cart.data.line_items.filter((p) -> return p.name == 'RETURN_INSURANCE')

  hasReturnInsurance: () ->
    returnInsurance = @cart.data.line_items.filter (i) -> i.name == 'RETURN_INSURANCE'
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
    returnInsurance = @cart.data.line_items.filter (i) -> i.name == 'RETURN_INSURANCE'
    lineItemId = returnInsurance[0].line_item_id
    $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')
    $('.js-returns-abc-option-message').addClass('hidden');
    @cart.removeProduct(lineItemId)

  couponFormSubmitHandler: (e) ->
    e.preventDefault() if e
    $input = $('form .promo-code-value:visible')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())
