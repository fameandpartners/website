window.page ||= {}

page.initCheckoutEditPage = () ->
  page = {
    ajax_callbacks: {}
    init: () ->
      $('.close').on('click', ->
        $('.auth-alert').hide()
      )

      $('.selectbox').outerWidth("100%")

      @ship_to_same_address = $("input[name='ship_to_address']").prop("checked")
      $("input[name='ship_to_address']").change =>
        @ship_to_same_address = $("input[name='ship_to_address']").prop("checked")
        page.updateShippingFormVisibility()

      $('.js-checkout-email-shipping').keyup ->
        $('.js-checkout-email-billing').val $(this).val()
        return

      $(document).on('change',  '#create_account', page.updatePasswordFieldsVisibility)
      $(document).on('click',   'form.checkout-form input[type=submit]', page.onAjaxLoadingHandler)

      $(document).on('change',  '#terms_and_conditions', page.updatePayButtonAvailability)
      $(document).on('click',   '.open-login-popup', page.openLoginPopup)

      $(document).on('click',   '.cvv-popup-toggle', page.toggleCVVCodePopup)

      $(document).on('keyup',   'input', page.updateAddressFormVisibility)
      $(document).on('change',  'input', page.updateAddressFormVisibility)

      if $('form.payment_details').is('.credit_card.pin')
        console.log('Assume AJAX payment') if app.debug || app.env == 'development'
        $(document).on('click',   '.place-order button', page.onAjaxLoadingHandler)
        $(document).on('click',   '.place-order button', page.orderProccessHandler)
        $(document).on('submit',  'form.payment_details.credit_card', page.doNothing)
      else
        console.log('Assume POST Payment') if app.debug || app.env == 'development'
        $(document).on('click',   '.place-order button', page.onFormSubmissionHandler)

      page.updateShippingFormVisibility()
      page.updatePasswordFieldsVisibility()
      page.updatePayButtonAvailability()
      page.updateAddressFormVisibility()

      # validation
      if app.debug || app.env == 'development'
        if $('.place-order button').length == 0
          console.log('WARRRRRGHNING! - credit card handlers have invalid selectors. cc payment will not work, probably')



    # Disable the button and set a helpful message
    safeSubmitButton: (button) ->
      if button.is('input')
        originalMessage = button.val()
      else if button.is('button')
        originalMessage = button.text()

      loadingMessage = button.data('loading') || 'Updating...'

      set: (message) ->
        if button.is('input')
          button.val(message)
        else if button.is('button')
          button.text(message)

      disableButton: ->
        this.set(loadingMessage)
        button.addClass('updating')
        # Delay disabling to allow for form submission, apparently.
        setTimeout(
          () ->
            button.attr('disabled', true)
        , 100
        )

      restoreButton: ->
        button.removeAttr('disabled').removeClass('updating')
        this.set(originalMessage)

    # Just disable the button, and place a nice message on it
    onFormSubmissionHandler: (e) ->
      $buttonManager = page.safeSubmitButton($(e.currentTarget))
      $buttonManager.disableButton()
#      setTimeout(100, $buttonManager.restoreButton)

    onAjaxLoadingHandler: (e) ->
      page.updateAddressFormVisibility()

      # shipping address buttons
      $form = $(e.currentTarget).closest('form')[0]
      if $form && _.isFunction($form.checkValidity) && !$form.checkValidity()
        # submit form in order to show validation messages
        # without messages updates & etc
        return true

      $buttonManager = page.safeSubmitButton($(e.currentTarget))
      $buttonManager.disableButton()

      page.addAjaxCallback('all', () ->
        $buttonManager.restoreButton()
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
      page.updatePayButtonAvailability()
      page.updateAddressFormVisibility()
      #$('.selectbox').not('.chosen-container').chosen()

    updateShippingFormVisibility: () ->
      if @ship_to_same_address == true
        $('[data-hook="billing_inner"]').hide()
        $('[data-hook="billing_inner"]').find(':input').prop('disabled', true)
        $('#order_use_shipping').val(1)
      else
        $('[data-hook="billing_inner"]').show()
        $('[data-hook="billing_inner"]').find(':input').prop('disabled', false)
        $('#order_use_shipping').val("")

    updatePasswordFieldsVisibility: () ->
      container = $('.checkout-content.line.form-global.passwords')
      if $('#create_account').is(':checked')
        container.find('input').prop('disabled', false)
        container.show()
      else
        container.find('input').prop('disabled', true)
        container.hide()

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
      states_required = $(country_field_id).find("option[value=#{country_id}]").data('states-required')

      if !states_required
        $(states_field_id).removeClass('required').prop('disabled', true)
        $(states_text_field_id).removeClass('required').prop('disabled', true)
        $(states_field_id).closest('.form-group').addClass('hidden')
      else if $(states_field_id).find("option[data-country=#{ country_id }]").length == 0
        $(states_field_id).closest('.form-group').removeClass('hidden')
        # show text input
        $(states_field_id).removeClass('required').prop('disabled', true).closest('span').addClass('hidden')
        $(states_text_field_id).addClass('required').removeClass('hidden').prop('disabled', false)
      else
        $(states_field_id).closest('.form-group').removeClass('hidden')
        $(states_text_field_id).removeClass('required').addClass('hidden').prop('disabled', true)
        # show available states
        $(states_field_id).find("option[data-country]").hide()
        $(states_field_id).find("option[data-country=#{ country_id }]").css('display', 'block')
        $(states_field_id).addClass('required').prop('disabled', false).closest('span').removeClass('hidden')

        # if currently select option not available for selected country, reset
        if !country_id || $(states_field_id).find('option:selected').data('country') != parseInt(country_id)
          $(states_field_id).val('')

        $(states_field_id).trigger('chosen:updated')

    openLoginPopup: (e) ->
      e.preventDefault()
      page.loginUserRequest()
        .done( (data, state) =>
          if data && !data.error && state == 'success'
            window.location.reload()
          else
            $(".auth-alert").show()
        )

    loginUserRequest: () ->
      formData = {
        spree_user: {
          email: $('#email').val(),
          password: $('#password').val()
        }
      }
      $.ajax(
        url: urlWithSitePrefix("/spree_user/sign_in")
        type: 'POST'
        dataType: 'json'
        data: $.param(formData)
      )

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

        if window.is_masterpass
          credit_card_data.address_country ||=  $('#order_bill_address_attributes_country_name').val()

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

        if window.is_masterpass
          disabled = $form.find(':input:disabled:not(.no-post)').removeAttr('disabled')
          params = $form.serialize()
          disabled.attr('disabled','disabled')

          params += ('&' + encodeURIComponent('payment_source[' + payment_method_id + '][cc_type]') + '=' + data.scheme + '&' + encodeURIComponent('payment_source[' + payment_method_id + '][gateway_payment_profile_id]') + '=' + data.token)

        else
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
