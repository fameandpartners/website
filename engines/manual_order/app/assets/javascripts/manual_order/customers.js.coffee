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
        email.val(data.email).prop('disabled', true)
        first_name.val(data.first_name).prop('disabled', true)
        last_name.val(data.last_name).prop('disabled', true)
        address1.val(data.address1)
        address2.val(data.address2)
        city.val(data.city)
        country.val(data.country_id)
        zipcode.val(data.zipcode)
        phone.val(data.phone)
        refreshStates(true)
        state.val(data.state_id)

        customerForm.prop('disabled', false)
        country.prop('disabled', false).trigger("chosen:updated")
        state.prop('disabled', false).trigger("chosen:updated")
    else
      clearCustomerForm()
      updateCountryAndState()

  country.on 'change', =>
    countryName = $('#forms_manual_order_country option:selected').text()
    countriesWithStatesArr = _.map(countriesWithStates, (value) ->
      value.country.name
    )
    if _.include(countriesWithStatesArr, countryName)
      refreshStates(false)
    else
      clearStates()
    updateStates()

  refreshStates = (status) ->
    state.html('<option></option>')
    countryName = $('#forms_manual_order_country option:selected').text()
    states = _.find(countriesWithStates, (value) ->
      return value.country.name == countryName
    ).country.states

    $.each states, (index, el) =>
      state.append $('<option>').attr('value', el.id).text(el.name)
    state.prop('disabled', status)

  clearStates = ->
    state.html('<option></option>')
    state.prop('disabled', true)

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

    existingCustomer.prop('disabled', false)
    updateExistingCustomer()

    customerForm.prop('disabled', true)
    country.prop('disabled', true)
    state.prop('disabled', true)
    updateCountryAndState()

  $('#customer_new').on 'click', =>
    clearCustomerForm()

    existingCustomer.val('')
    existingCustomer.prop('disabled', true)
    updateExistingCustomer()

    customerForm.prop('disabled', false)
    country.prop('disabled', false)
    updateCountryAndState()

  clearCustomerForm = ->
    email.val('').prop('disabled', false)
    first_name.val('').prop('disabled', false)
    last_name.val('').prop('disabled', false)
    address1.val('')
    address2.val('')
    city.val('')
    country.val('')
    state.val('')
    zipcode.val('')
    phone.val('')

