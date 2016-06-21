$ ->
  searchSelect = $('#forms_manual_order_search')
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
    console.log 'change'
    url = userUrl.replace(/:user_id/, searchSelect.val()) if searchSelect.val()
    if url
      $.getJSON url, (data) =>
        $('#forms_manual_order_email').val(data.email)
        $('#forms_manual_order_first_name').val(data.first_name)
        $('#forms_manual_order_last_name').val(data.last_name)
        $('#forms_manual_order_address1').val(data.address1)
        $('#forms_manual_order_address2').val(data.address2)
        $('#forms_manual_order_city').val(data.city)
        $('#forms_manual_order_zipcode').val(data.zipcode)
        $('#forms_manual_order_phone').val(data.phone)
