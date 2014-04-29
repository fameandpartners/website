$('#dev_console').ready ->

  window.fill = (step) ->
    if step == 'address' || step == 1
      fill_addresses()
    else if step == 'payment' || step == 2
      fill_payments()
    else
      fill_addresses()
      fill_payments()

  window.fill_addresses = () ->
    fill_address('bill_address')
    if !$('#order_use_billing').is(':checked')
      fill_address('ship_address')

  window.fill_address = (address) ->
    date = new Date()
    timestamp = date.getTime()

    # billing addrsss
    $("#order_#{address}_attributes_firstname").val('John')
    $("#order_#{address}_attributes_lastname").val('Smith')
    $("#order_#{address}_attributes_email").val("malleus.petrov+#{timestamp}@gmail.com")
    $("#order_#{address}_attributes_address1").val('Saint Charles')
    $("#order_#{address}_attributes_address2").val('23/45')
    $("#order_#{address}_attributes_city").val('New Orleans')
    $("#order_#{address}_attributes_zipcode").val(123456)
    $("#order_#{address}_attributes_phone").val('0123456789')

    country_id = $("#order_#{address}_attributes_country_id").find("option:contains('United States')").val()
    $("#order_#{address}_attributes_country_id").val(country_id).trigger("chosen:updated")

    state_id = $("#order_#{address}_attributes_state_id").find("option:last").val()
    $("#order_#{address}_attributes_state_id").val(state_id).trigger("chosen:updated")


  window.fill_payments = () ->
    # card tab
    $('#payment_source_6_number').val('5520000000000000')
    $('#payment_source_6_full_name').val('NotJohn NotSmith')
    $('#payment_source_6_year').val(2015)
    $('#card_code').val(123)
