$ ->
  urlTemplate = '/fame_admin/customisation/customisation_values/option_values/:product_id'
  productSelect = $('#customization_product_id')

  productSelect.on 'change', =>
    console.log 'PRODUCT CHANGED'
    url = urlTemplate.replace(/:product_id/, productSelect.val()) if productSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data, (index, el) =>
          console.log el
    else
      console.log 'EMPTY URL'
