#= require templates/shopping_cart_summary
window.ShoppingCartSummary = class ShoppingCartSummary
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_summary']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '#cart')
    @value_proposition = options.value_proposition
    @shipping_message = options.shipping_message

    _.bindAll(@, 'render', 'removeProductHandler', 'removeProductCustomizationHandler', 'removeProductMakingOptionHandler', 'couponFormSubmitHandler')

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', '.customization-remove', @removeProductCustomizationHandler)
    @$container.on('click', '.making-option-remove', @removeProductMakingOptionHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)
    @cart.on('change', @render)
    @initMasterPass(options)
    @

  initMasterPass: (options) =>
    @masterpass_link = options.masterpass_link
    @$masterpass_cart_callback_uri = options.masterpass_cart_callback_uri
    @$overlay = $("#shadow-layer")
    @masterpass_clicked = false
    $(@masterpass_link).on('click', @masterpassOpenHandler)

  masterpassOpenHandler: (e) =>
    e.preventDefault() if e
    return if @cart.item_count == 0

    @masterpass_clicked = true
    spinner = new Spinner().spin();
    @$overlay.append spinner.el;
    @$overlay.addClass('most-front');

    overlay = @$overlay;
    $.getJSON(@$masterpass_cart_callback_uri).done (data) ->
      console.log data
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

  render: () ->
    @$container.html(@template(cart: @cart.data, value_proposition: @value_proposition, shipping_message: @shipping_message ))

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    @cart.removeProduct(line_item_id)

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
    $input = $('.product-form-top .promo-code-value')
    $input = $('.product-form-side .promo-code-value') if $input.val() == ''
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())
