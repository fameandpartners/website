$('.checkout.edit').ready ->
  page = {
    init: () ->
      $(document).on('change', '#order_use_billing', page.updateShippingFormVisibility)
      $(document).on('change', '#create_account', page.updatePasswordFieldsVisibility)
      $(document).on('click', 'form input[type=submit]', page.onAjaxLoadingHandler)

      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()

    onAjaxLoadingHandler: (e) ->
      $button = $(e.currentTarget)
      previous_message = $button.val()
      loading_message = $button.data('loading') || 'Updating...'
      $button.attr('disabled', true).val(loading_message).addClass('updating')
      # unlock button after 5 second - we can have 500 error on server
      setTimeout(
        () ->
          $button.removeAttr('disabled').val(previous_message).removeClass('updating')
        , 5000
      )

    onAjaxSuccessHandler: (e) ->
      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()

    onAjaxFailureHandler: (e) ->
      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()
      scrollScreenTo($("#errorExplanation"))

    updateShippingFormVisibility: () ->
      if $('#order_use_billing').is(':checked')
        $('[data-hook="shipping_inner"]').hide()
        $('[data-hook="shipping_inner"]').find(':input').prop('disabled', true)
      else
        $('[data-hook="shipping_inner"]').show()
        $('[data-hook="shipping_inner"]').find(':input').prop('disabled', false)

    updatePasswordFieldsVisibility: () ->
      if $('#create_account').is(':checked')
        $('form#new_user .passwords input').prop('disabled', false)
        $('form#new_user .passwords').show()
      else
        $('form#new_user .passwords input').prop('disabled', true)
        $('form#new_user .passwords').hide()

  }

  page.init()

  window.checkout_page = page
