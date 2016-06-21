$ ->
  $('#forms_manual_order_search').ajaxChosen
    minTermLength: 2
    type: 'GET'
    url: '/fame_admin/manual_orders/autocomplete'
    dataType: 'json'
  , (data) ->
    results = []
    $.each data['manual_orders'], (i, val) ->
      results.push
        value: val.id
        text: val.value
    results


