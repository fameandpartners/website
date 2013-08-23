$('.checkout.edit').ready ->
  window.fill = () ->
    date = new Date()
    timestamp = date.getTime()

    # personal
    $('#user_email').val("malleus.petrov+#{timestamp}@gmail.com")
    $('#user_first_name').val('John')
    $('#user_last_name').val('Smith')

    # billing addrsss
    $('#order_bill_address_attributes_firstname').val('John')
    $('#order_bill_address_attributes_lastname').val('Smith')
    $('#order_bill_address_attributes_address1').val('Saint Charles')
    $('#order_bill_address_attributes_address2').val('23/45')
    $('#order_bill_address_attributes_city').val('New Orleans')
    #$('#order_bill_address_attributes_country_id').val(49)
    #$('#order_bill_address_attributes_state_id').val(23)
    $('#order_bill_address_attributes_zipcode').val(123456)
    $('#order_bill_address_attributes_phone').val('0123456789')

    # shipping addrss
    $('#order_ship_address_attributes_firstname').val('John')
    $('#order_ship_address_attributes_lastname').val('Smith')
    $('#order_ship_address_attributes_address1').val('Saint Charles')
    $('#order_ship_address_attributes_address2').val('23/45')
    $('#order_ship_address_attributes_city').val('New Orleans')
    $('#order_ship_address_attributes_country_id').val(109)
    $('#order_ship_address_attributes_state_id').val(55)
    $('#order_ship_address_attributes_zipcode').val(123456)
    $('#order_ship_address_attributes_phone').val('0123456789')
    
    # card tab
    $('#payment_source_6_number').val('5520000000000000')
    $('#payment_source_6_full_name').val('NotJohn NotSmith')
    $('#payment_source_6_year').val(2015)
    $('#card_code').val(123)
