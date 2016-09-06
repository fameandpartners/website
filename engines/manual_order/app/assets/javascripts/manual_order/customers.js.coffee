$ ->
  existingCustomer = $('#forms_manual_order_existing_customer')
  customerForm = $('#customer_form')
  email = $('#forms_manual_order_email')
  first_name = $('#forms_manual_order_first_name')
  last_name = $('#forms_manual_order_last_name')
  address1 = $('#forms_manual_order_address1')
  address2 = $('#forms_manual_order_address2')
  city = $('#forms_manual_order_city')
  country = $('#forms_manual_order_country')
  state = $('#forms_manual_order_state')
  zipcode = $('#forms_manual_order_zipcode')
  phone = $('#forms_manual_order_phone')

  searchUrl = '/fame_admin/manual_orders/autocomplete_customers'
  userUrl = '/fame_admin/manual_orders/user/:user_id'

  existingCustomer.ajaxChosen
    minTermLength: 2
    type: 'GET'
    url: searchUrl
    dataType: 'json'
  , (data) ->
    results = []
    $.each data['manual_orders'], (i, val) ->
      results.push
        value: val.id
        text: val.value
    results

  existingCustomer.on 'change', =>
    url = userUrl.replace(/:user_id/, existingCustomer.val()) if existingCustomer.val()
    if url
      $.getJSON url, (data) =>
        email.val(data.email)
        first_name.val(data.first_name)
        last_name.val(data.last_name)
        address1.val(data.address1)
        address2.val(data.address2)
        city.val(data.city)
        country.val(data.country_id)
        zipcode.val(data.zipcode)
        phone.val(data.phone)
        refreshStates(true)
        state.val(data.state_id)
        updateCountryAndState()
    else
      clearCustomerForm()
      updateCountryAndState()

  country.on 'change', =>
    countryName = $('#forms_manual_order_country option:selected').text()
    countriesWithStatesArr = countriesWithStates.map((value, _) ->
      value.country.name
    )
    if countriesWithStatesArr.includes(countryName)
      refreshStates(false)
    else
      clearStates()
    updateStates()

  refreshStates = (status) ->
    state.html('<option></option>')
    countryName = $('#forms_manual_order_country option:selected').text()
    states = countriesWithStates.find((value, _) ->
      return value.country.name == countryName
    ).country.states
    $.each states, (index, el) =>
      state.append $('<option>').attr('value', el.id).text(el.name)
    state.attr('disabled', status)

  clearStates = ->
    state.html('<option></option>')
    state.attr('disabled', true)

  updateStates = ->
    state.trigger('chosen:updated')

  updateCountryAndState = ->
    country.trigger('chosen:updated')
    state.trigger('chosen:updated')

  updateExistingCustomer = ->
    existingCustomer.trigger('chosen:updated')

  $('#customer_existing').on 'click', =>
    country.val('')
    state.val('')

    existingCustomer.attr('disabled', false)
    updateExistingCustomer()

    customerForm.attr('disabled', true)
    country.attr('disabled', true)
    state.attr('disabled', true)
    updateCountryAndState()

  $('#customer_new').on 'click', =>
    clearCustomerForm()

    existingCustomer.val('')
    existingCustomer.attr('disabled', true)
    updateExistingCustomer()

    customerForm.attr('disabled', false)
    country.attr('disabled', false)
    updateCountryAndState()

  clearCustomerForm = ->
    email.val('')
    first_name.val('')
    last_name.val('')
    address1.val('')
    address2.val('')
    city.val('')
    country.val('')
    state.val('')
    zipcode.val('')
    phone.val('')

