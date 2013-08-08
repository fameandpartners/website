$('.checkout.edit').ready ->
  page = {
    ajax_callbacks: {}
    init: () ->
      $(document).on('change', '#order_use_billing', page.updateShippingFormVisibility)
      $(document).on('change', '#create_account', page.updatePasswordFieldsVisibility)
      $(document).on('click', 'form input[type=submit]', page.onAjaxLoadingHandler)
      $(document).on('click', '.place-order button', page.onAjaxLoadingHandler)
      $(document).on('click', '.place-order button', page.orderProccessHandler)

      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()

    onAjaxLoadingHandler: (e) ->
      $button = $(e.currentTarget)
      if $button.is('input')
        previous_message = $button.val()
      else if $button.is('button')
        previous_message = $button.text()

      loading_message = $button.data('loading') || 'Updating...'

      if $button.is('input')
        $button.val(loading_message)
      else if $button.is('button')
        $button.text(loading_message)

      $button.addClass('updating')
      # disable button only after form submitting! Otherwise, the form will not be sent!
      setTimeout(
        () ->
          $button.attr('disabled', true)
        , 100
      )
      page.addAjaxCallback('all', () ->
        $button.removeAttr('disabled').removeClass('updating')

        if $button.is('input')
          $button.val(previous_message)
        else if $button.is('button')
          $button.text(previous_message)
      )

    addAjaxCallback: (state, callback) ->
      page.ajax_callbacks[state] or= []
      if !_.contains(page.ajax_callbacks[state], callback)
        page.ajax_callbacks[state].push(callback)
      return true

    callAjaxCallbacks: () ->
      _.each(arguments, (state) ->
        callbacks = page.ajax_callbacks[state] || []
        _.each(callbacks, (callback) ->
          callback.call()
        )
      )
      return true

    onAjaxSuccessHandler: (e) ->
      page.refreshFormView()
      page.callAjaxCallbacks('success', 'all')

    onAjaxFailureHandler: (e) ->
      page.refreshFormView()
      scrollScreenTo($("#errorExplanation"))
      page.callAjaxCallbacks('failure', 'all')

    refreshFormView: () ->
      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()
      $('.selectbox').chosen()

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

    orderProccessHandler: (event) ->
      $form = $('form.payment_details')

      $form.find('.errorExplanation').remove()

      if $form.is('.credit_card.pin')
        credit_card_data =
          number: $form.find('[name*="[number]"]').val()
          name: $form.find('[name*="[full_name]"]').val()
          expiry_year: $form.find('[name*="[year]"]').val()
          expiry_month: $form.find('[name*="[month]"]').val()
          cvc: $form.find('[name*="[verification_value]"]').val()
          address_country: $('#order_bill_address_attributes_country_id').find('option:selected').text()
          address_city: $('#order_bill_address_attributes_city').val()
          address_line1: $('#order_bill_address_attributes_address1').val()
        Pin.createToken(credit_card_data, page.pinResponseHandler)

    pinResponseHandler: (response) ->
      $form = $('form.payment_details.credit_card.pin')

      if response.response
        data = response.response
        $token_field = $('<input/>')
          .attr('type', 'hidden')
          .attr('name', $form.find('[name*="[number]"]').attr('name').replace('number', 'gateway_payment_profile_id'))
          .val(data.token)
        $type_field = $('<input/>')
          .attr('type', 'hidden')
          .attr('name', $form.find('[name*="[number]"]').attr('name').replace('number', 'cc_type'))
          .val(data.scheme)
        $form.find(':input:visible').attr('disabled', true)
        $form.append($token_field)
        $form.append($type_field)
        $form.submit()
      else
        $errors = $('<div/>').addClass('errorExplanation')
        $header = $('<h3/>').text(response.error_description)
        $list = null;
        if (response.messages)
          $list = $('<ul/>');
          $.each response.messages, (index, message) ->
            $list.append($('<li/>').text(message.message))

        $errors.append($header).append($list)

        $form.prepend($errors)
        page.onAjaxFailureHandler()
  }

  page.init()

  window.checkout_page = page
