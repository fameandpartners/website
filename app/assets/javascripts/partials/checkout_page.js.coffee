$('.checkout.edit').ready ->
  window.toggleBillingAddress = ->
    if $('#order_use_billing').is(':checked')
      $('[data-hook="shipping_inner"]').hide()
      $('[data-hook="shipping_inner"]').find(':input').prop('disabled', true)
    else
      $('[data-hook="shipping_inner"]').show()
      $('[data-hook="shipping_inner"]').find(':input').prop('disabled', false)


  toggleBillingAddress()

  $(document).on('change', '#order_use_billing', toggleBillingAddress);
