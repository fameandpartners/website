$(document).ready ->
  $('#new_forms_manual_order').validate
    ignore: ":hidden:not(select), .chosen-search input"
    debug: true
    rules:
      'forms_manual_order[style_name]':
        required: true
      'forms_manual_order[size]':
        required: true
      'forms_manual_order[length]':
        required: true
      'forms_manual_order[color]':
        required: true
      'forms_manual_order[existing_customer]':
        required: '#customer_existing:checked'
      'forms_manual_order[email]':
        required: '#customer_new:checked'
        email: true
      'forms_manual_order[first_name]':
        required: '#customer_new:checked'
      'forms_manual_order[last_name]':
        required: '#customer_new:checked'
      'forms_manual_order[address1]':
        required: '#customer_new:checked'
      'forms_manual_order[city]':
        required: '#customer_new:checked'
      'forms_manual_order[country]':
        required: '#customer_new:checked'
      'forms_manual_order[state]':
        required: (el) ->
          country_name = $('#forms_manual_order_country option:selected').text()
          countries_with_states_arr = countries_with_states.map((value, _) ->
            value.country.name
          )
          return countries_with_states_arr.includes(country_name)
      'forms_manual_order[zipcode]':
        required: '#customer_new:checked'
      'forms_manual_order[phone]':
        required: '#customer_new:checked'
    submitHandler: (form) ->
      form.submit()
      return
