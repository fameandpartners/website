# user products slider in header
# 'view' element
#= require templates/shopping_bag
window.ShoppingBag = class ShoppingBag
  transition_end_events = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'

  constructor: (options = {}) ->
    @template   = JST['templates/shopping_bag']
    @cart       = options.cart # window.shopping_cart
    @rendered   = false
    @masterpass_clicked = false
    @auto_open  = options.auto_open
    @country_code = options.country_code
    @masterpass_cart_callback_uri = options.masterpass_cart_callback_uri

    @$overlay   = $(options.overlay || '#shadow-layer')
    @$container = $(options.container || '#cart')
    @masterpass_link = options.masterpass_link
    @freeStyling     = options.free_styling
    @freeDelivery    = options.free_delivery
    @customerService = options.customer_service
    # TODO: Check if we still need the following 2 items
    @value_proposition  = options.value_proposition
    @shipping_message  = options.shipping_message

    _.bindAll(@,
      'closeHandler',
      'openHandler',
      'open',
      'close',
      'customizationPrice',
      'makingOptionDescriptionTag',
      'render',
      'removeProductHandler',
      'couponFormSubmitHandler',
      'removeProductCustomizationHandler',
      'removeProductMakingOptionHandler',
      'masterpassOpenHandler',
      'hasReturnInsurance',
      'hasReturnDiscount'
    )

    $(options.toggle_link || '.js-header-toolbar .js-trigger-shopping-bag').on('click', @openHandler)

    @$container.on('click', '.close-cart', @closeHandler)
    @$overlay.on('click', @closeHandler)
    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('click', '.customization-remove', @removeProductCustomizationHandler)
    @$container.on('click', '.making-option-remove', @removeProductMakingOptionHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)

    @cart.on('change', @render)

    if @auto_open
      @open()
    @

  addEventToMasterPassButton: () ->
    $(@masterpass_link || '#buyWithMasterPass').on('click', @masterpassOpenHandler)

  customizationPrice: (displayPriceObj) ->
    currencySymbol = displayPriceObj.money.currency.html_entity
    displayTotal = parseInt(displayPriceObj.money.fractional, 10) / displayPriceObj.money.currency.subunit_to_unit
    currencySymbol + displayTotal

  makingOptionDescriptionTag: (makingOptions) ->
    if (makingOptions[0].name.toLowerCase() == 'deliver later')
      return '(' + makingOptions[0].display_discount + ')'
    else if (makingOptions[0].name.toLowerCase() == 'deliver express')
      return '(+' + makingOptions[0].display_discount + ')'

  hasReturnInsurance: () ->
    if (@cart.data)
      returnInsurance = @cart.data.products.filter (i) -> i.name == 'RETURN_INSURANCE'
      returnInsurance.length

  hasReturnDiscount: () ->
    if (@cart.data.promocode)
      @cart.data.promocode.indexOf('DELIVERYDISC') > -1

  makingOptionsDeliveryPeriod: (makingOptions, deliveryPeriod) ->
    if (makingOptions[0])
      return makingOptions[0].delivery_period

    deliveryPeriod

  render: () ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/order_delivery_date")
      type: 'GET'
      success: (data) =>
        @date_vars = {}
        if data
          @date_vars["start_date"]                = data.start_date
          @date_vars["end_date"]                  = data.end_date
          @date_vars["start_date_express"]        = data.start_date_express
          @date_vars["end_date_express"]          = data.end_date_express
          @date_vars["start_date_non_express"]    = data.start_date_non_express
          @date_vars["end_date_non_express"]      = data.end_date_non_express

        @$container.html(@template(
          cart: @cart.data,
          country_code: @country_code,
          customizationPrice: @customizationPrice,
          makingOptionDescriptionTag: @makingOptionDescriptionTag,
          hasReturnInsurance: @hasReturnInsurance,
          hasReturnDiscount: @hasReturnDiscount,
          makingOptionsDeliveryPeriod: @makingOptionsDeliveryPeriod,
          value_proposition: @value_proposition,
          shipping_message: @shipping_message,
          date_vars: @date_vars
        ))
        @addEventToMasterPassButton()
        @rendered = true
    )


  close: () ->
    @$overlay.removeClass('is-visible')
    @$container.removeClass('speed-in').one(transition_end_events, () ->
      $('body').removeClass('overflow-hidden')
    )

  open: () ->
    @render() if !@rendered
    @$container.addClass('speed-in').one(transition_end_events, () ->
      $('body').addClass('overflow-hidden')
    )
    @$overlay.addClass('is-visible')
    return

  openHandler: (e) ->
    e.preventDefault() if e
    if @cart.isLoaded()
      @open()
    else
      @cart.one('load', @open)
      @cart.load()

  closeHandler: (e) ->
    e.preventDefault() if e
    @close() if !@masterpass_clicked

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    @cart.removeProduct(line_item_id)
    @render()

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
    $input = @$container.find('#promotion-code')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())

  masterpassOpenHandler: (e) ->
    e.preventDefault() if e
    return if @cart.item_count == 0

    @masterpass_clicked = true
    spinner = new Spinner().spin();
    @$overlay.append spinner.el;
    @$overlay.addClass('most-front');

    overlay = @$overlay;
    $.getJSON(@masterpass_cart_callback_uri).done (data) ->
      @masterpass_clicked = false
      spinner.stop()
      overlay.removeClass('most-front');

      if data.hasOwnProperty('request_token') and data.hasOwnProperty('callback_domain') and data.hasOwnProperty('checkout_identifier') and data.hasOwnProperty('shipping_suppression') and data.hasOwnProperty('accepted_cards') and data.hasOwnProperty('cart_callback_path')
        MasterPass.client.checkout
          requestToken: data.request_token
          callbackUrl: data.cart_callback_path
          merchantCheckoutId: data.checkout_identifier
          allowedCardTypes: data.accepted_cards
          cancelCallback: data.callback_domain
          suppressShippingAddressEnable: data.shipping_suppression
          loyaltyEnabled: 'false'
          requestBasicCheckout: false,
          version: 'v6'

        if data.hasOwnProperty('commerce_tracking') and data.commerce_tracking == true
          axel = Math.random() + ''
          a = axel * 10000000000000
          ifrm = document.createElement('IFRAME')
          ifrm.setAttribute 'src', 'https://4754606.fls.doubleclick.net/activityi;src=4754606;type=mpau;cat=famep00;ord=\' + a + \'?'
          ifrm.style.width = 1 + 'px'
          ifrm.style.height = 1 + 'px'
          ifrm.style.frameborder = 0
          ifrm.style.display = 'none'
          document.body.appendChild ifrm
