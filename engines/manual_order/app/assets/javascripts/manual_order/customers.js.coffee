$ ->
  searchSelect = $('#forms_manual_order_search')
  customerform = $('#customer_form')
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

  searchUrl = '/fame_admin/manual_orders/autocomplete'
  userUrl = '/fame_admin/manual_orders/user/:user_id'

  searchSelect.ajaxChosen
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

  searchSelect.on 'change', =>
    url = userUrl.replace(/:user_id/, searchSelect.val()) if searchSelect.val()
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

        switch $('#forms_manual_order_country option:selected').text()
          when 'Australia' then refreshStates(states_au)
          when 'United States' then refreshStates(states_us)
          when 'Canada' then refreshStates(states_ca)

        state.val(data.state_id)

        updateCountryAndState()

  refreshStates = (states) ->
    state.html('<option></option>')
    $.each states, (index, el) =>
      state.append $('<option>').attr('value', el.id).text(el.name)

  updateCountryAndState = ->
    country.trigger('chosen:updated')
    state.trigger('chosen:updated')

  $('#customer_existing').on 'click', =>
    customerform.attr('disabled', 'disabled')

  $('#customer_new').on 'click', =>
    customerform.removeAttr('disabled')
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

    updateCountryAndState()

