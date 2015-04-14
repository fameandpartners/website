window.checkout ||= {}

window.checkout.payment_step = {
  init: (options = {}) ->
    $(document).on('click', 'form.checkout-form input[type=submit]', checkout.page.onAjaxLoadingHandler)
    if options.gateway_type == 'pin'
      initPinGateway.options(options.gateway_options)
    else if options.gateway_type == 'nab'
      initNabGateway.options(options.gateway_options)

  initPinGateway: (options) ->
    Pin.setPublishableKey(options.key)

  initNabGateway: (options) ->
    # nothing for now
}
