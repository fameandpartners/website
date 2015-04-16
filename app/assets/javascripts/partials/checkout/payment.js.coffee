window.checkout ||= {}

window.fill = () ->
  $('input#number').val('4444333322221111')
  $('input#name').val('john smith')
  $('input#card_code').val('123')

window.checkout.payment_step = {
  pin_request_in_process: false
  payment_request_in_process: false
  bill_address: {}

  init: (options = {}) ->
    checkout.payment_step.bill_address = (options.bill_address || {})

    if options.gateway_type == 'pin'
      checkout.payment_step.initPinGateway(options.gateway_options)
    else if options.gateway_type == 'nab'
      checkout.payment_step.initNabGateway(options.gateway_options)

    $(document).on('click', 'form.checkout-form input[type=submit]', checkout.page.onAjaxLoadingHandler)

  initPinGateway: (options) ->
    Pin.setPublishableKey(options.key)
    $(document).on('click', '.place-order button', checkout.payment_step.orderPinProcessHandler)

  initNabGateway: (options) ->
    # nothing for now
    #address_form
    # 4444333322221111

  # general
  getCreditCardData: () ->
    $form = $('form.payment_details')

    credit_card_data =
      number: $form.find('[name*="[number]"]').val()
      name: $form.find('[name*="[full_name]"]').val()
      expiry_year: $form.find('[name*="[year]"]').val()
      expiry_month: $form.find('[name*="[month]"]').val()
      cvc: $form.find('[name*="[verification_value]"]').val()
      address_country: $('#order_bill_address_attributes_country_id').find('option:selected').text()
      address_city: $('#order_bill_address_attributes_city').val()
      address_line1: $('#order_bill_address_attributes_address1').val()

    bill_address = checkout.payment_step.bill_address
    if checkout.payment_step.bill_address
      credit_card_data.address_country  ||= bill_address.country
      credit_card_data.address_city     ||= bill_address.city
      credit_card_data.address_line1    ||= bill_address.address1

    credit_card_data

  getPaymentSourceDetails: () ->
    $form = $('form.payment_details.credit_card.pin')

    payment_method_id = $form.find('[name$="[payment_method_id]"]:first').val()
    authenticity_token = $form.find('[name="authenticity_token"]').val()
    _method = $form.find('[name="_method"]').val()

    params = {}
    params['authenticity_token'] = authenticity_token
    params['_method'] = _method
    params['order'] = {}
    params['payment_source'] = {}
    params['payment_source'][payment_method_id] = {}
    params['payment_source'][payment_method_id]['cc_type'] = null
    params['payment_source'][payment_method_id]['gateway_payment_profile_id'] = null

    params


  # NAB
  orderNabProcessHandler: (event) ->
    return if checkout.payment_step.pin_request_in_process
    checkout.payment_step.pin_request_in_process = true

    $form = $('form.payment_details')
    $form.find(':input').attr('disabled', true)
    $form.find('.errorExplanation').remove()

    credit_card_data = checkout.payment_step.getCreditCardData()

    params = checkout.payment_step.getPaymentSourceDetails()
    # we don't use token or cc details
    params = $.param(params)
    params += ('&' + encodeURIComponent('order[payments_attributes][][payment_method_id]') + '=' + payment_method_id)

    $.ajax
      type: 'POST'
      url: $form.attr('action')
      data: params
      dataType: 'script'


  # PIN
  orderPinProcessHandler: (event) ->
    return if checkout.payment_step.pin_request_in_process
    checkout.payment_step.pin_request_in_process = true

    $form = $('form.payment_details')
    $form.find(':input').attr('disabled', true)
    $form.find('.errorExplanation').remove()

    credit_card_data = checkout.payment_step.getCreditCardData()
    Pin.createToken(credit_card_data, checkout.payment_step.pinResponseHandler)

  pinResponseHandler: (response) ->
    $form = $('form.payment_details.credit_card.pin')

    if response.response
      return if checkout.payment_step.payment_request_in_process
      checkout.payment_step.payment_request_in_process = true

      data = response.response

      params = checkout.payment_step.getPaymentSourceDetails()
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
      checkout.page.onAjaxFailureHandler()

      checkout.payment_step.pin_request_in_process = false
}
