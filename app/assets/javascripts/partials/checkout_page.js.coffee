page.initCheckoutEditPage = () ->
  page = {
    ajax_callbacks: {}
    init: () ->
      $(document).on('change',  '#order_use_billing', page.updateShippingFormVisibility)
      $(document).on('change',  '#create_account', page.updatePasswordFieldsVisibility)
      $(document).on('click',   'form.checkout-form input[type=submit]', page.onAjaxLoadingHandler)
      $(document).on('click',   '.place-order button', page.onAjaxLoadingHandler)
      $(document).on('click',   '.place-order button', page.orderProccessHandler)
      $(document).on('submit',  'form.payment_details.credit_card', page.doNothing)
      $(document).on('change',  '#terms_and_conditions', page.updatePayButtonAvailability)
      $(document).on('click',   '.open-login-popup', page.openLoginPopup)
      
      $(document).on('click',   '.cvv-popup-toggle', page.toggleCVVCodePopup)

      $(document).on('keyup',   'input', page.updateAddressFormVisibility)
      $(document).on('change',  'input', page.updateAddressFormVisibility)

      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()
      page.updateDatepicker()
      page.updatePayButtonAvailability()
      page.updateAddressFormVisibility()

      # validation
      if app.debug || app.env == 'development'
        if $('.place-order button').length == 0
          console.log('WARRRRRGHNING! - credit card handlers have invalid selectors. cc payment will not work, probably')

    onAjaxLoadingHandler: (e) ->
      page.updateAddressFormVisibility()

      # shipping address buttons
      $form = $(e.currentTarget).closest('form')[0]
      if $form && _.isFunction($form.checkValidity) && !$form.checkValidity()
        # submit form in order to show validation messages
        # without messages updates & etc
        return true

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
      page.updateDatepicker()
      page.updatePayButtonAvailability()
      page.updateAddressFormVisibility()
      #$('.selectbox').not('.chosen-container').chosen()

    updateShippingFormVisibility: () ->
      if $('#order_use_billing').is(':checked')
        $('[data-hook="shipping_inner"]').hide()
        $('[data-hook="shipping_inner"]').find(':input').prop('disabled', true)
      else
        $('[data-hook="shipping_inner"]').show()
        $('[data-hook="shipping_inner"]').find(':input').prop('disabled', false)

    updatePasswordFieldsVisibility: () ->
      container = $('.checkout-content.line.form-global.passwords')
      if $('#create_account').is(':checked')
        container.find('input').prop('disabled', false)
        container.show()
      else
        container.find('input').prop('disabled', true)
        container.hide()

    updateDatepicker: () ->
      $('#order_required_to').datepicker({
        minDate: '+1D',
        showButtonPanel: true,
        dateFormat: 'yy-mm-dd'
      })

    doNothing: (event) ->
      event.preventDefault()
      false

    updatePayButtonAvailability: (event) ->
      buttons = $("*[data-require='terms_and_conditions']")
      links = $('#paypal_button')

      if true || $('#terms_and_conditions').is(':checked')
        buttons.prop('disabled', false)
        links.prop('disabled', false)
        links.off('click', page.doNothing)
      else
        links.on('click', page.doNothing)
        links.prop('disabled', true)
        buttons.prop('disabled', true)
      true

    updateAddressFormVisibility: (event) ->
      $('.grid-container.form-global.form-address').each((index, element) ->
        $container = $(element)
        firstname = $container.find('input[id$=address_attributes_firstname]').val()
        lastname = $container.find('input[id$=address_attributes_lastname]').val()
        email = $container.find('input[id$=address_attributes_email]').val()

        if (_.isEmpty(firstname) || _.isEmpty(lastname) || _.isEmpty(email))
          $container.find(".input.clearfix[data-require=user-credentials]").addClass('hide')
          $container.find(".submit-button input").attr('disabled', true)
        else
          $container.find(".input.clearfix[data-require=user-credentials]").removeClass('hide')
          $container.find(".submit-button input").removeAttr('disabled')
      )
      # if user filled first last email, show other elements
      # otherwise - hide&disable

    updateStatesVisibility: (country_field_id, states_field_id, states_text_field_id) ->
      country_id = $(country_field_id).val()
      $(states_field_id).find("option[data-country]").hide()
      if $(states_field_id).find("option[data-country=#{ country_id }]").length == 0
        # show input
        $(states_field_id).addClass('hidden').removeClass('required').prop('disabled', true)
        $(states_text_field_id).addClass('required').removeClass('hidden').prop('disabled', false)
      else
        $(states_text_field_id).addClass('hidden').removeClass('required').prop('disabled', true)
        # show available states
        $(states_field_id).addClass('required').removeClass('hidden').prop('disabled', false)
        $(states_field_id).find("option[data-country=#{ country_id }]").show()

        # if currently select option not available for selected country, reset
        if !country_id || $(states_field_id).find('option:selected').data('country') != parseInt(country_id)
          $(states_field_id).val('')

    openLoginPopup: (e) ->
      if window.popups && window.popups.LoginPopup()
        e.preventDefault()
        popup = new window.popups.LoginPopup()
        popup.show()
      else
        # redirecting instead login popup
        console.log('redirecting to login')

    toggleCVVCodePopup: (e) ->
      e.preventDefault()
      $('#cvv-popup .modal-container').toggle()

    orderProccessHandler: (event) ->
      return if page.pin_request_in_process

      page.pin_request_in_process = true

      $form = $('form.payment_details')

      $form.find(':input').attr('disabled', true)

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

        if window.bill_address
          credit_card_data.address_country  ||= window.bill_address.country
          credit_card_data.address_city     ||= window.bill_address.city
          credit_card_data.address_line1    ||= window.bill_address.address1

        Pin.createToken(credit_card_data, page.pinResponseHandler)

    pinResponseHandler: (response) ->
      $form = $('form.payment_details.credit_card.pin')

      console.log(response.response)

      if response.response
        return if page.payment_request_in_process

        page.payment_request_in_process = true

        data = response.response


        payment_method_id = $form.find('[name$="[payment_method_id]"]:first').val()
        authenticity_token = $form.find('[name="authenticity_token"]').val()
        _method = $form.find('[name="_method"]').val()

        params = {}
        params['authenticity_token'] = authenticity_token
        params['_method'] = _method
        params['order'] = {}
        params['payment_source'] = {}
        params['payment_source'][payment_method_id] = {}
        params['payment_source'][payment_method_id]['cc_type'] = data.scheme
        params['payment_source'][payment_method_id]['gateway_payment_profile_id'] = data.token

        params = $.param(params)

        params += ('&' + encodeURIComponent('order[payments_attributes][][payment_method_id]') + '=' + payment_method_id)

        $.ajax
          type: 'POST'
          url: $form.attr('action')
          data: params
          dataType: 'script'

      else
        $form.find(':input').attr('disabled', false)

        $errors = $('<div/>').addClass('errorExplanation')
        $header = $('<h3/>').text(response.error_description)
        $list = null
        if (response.messages)
          $list = $('<ul/>')
          $.each response.messages, (index, message) ->
            $list.append($('<li/>').text(message.message))

        $errors.append($header).append($list)

        $form.prepend($errors)
        page.onAjaxFailureHandler()

        page.pin_request_in_process = false
  }
  page.init()
  window.checkout_page = page
  page
