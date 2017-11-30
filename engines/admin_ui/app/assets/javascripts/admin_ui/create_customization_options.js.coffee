$ ->
  urlTemplate = '/fame_admin/customisation/customisation_values/option_values/:product_id'
  productSelect = $('#customization_product_id')
  customSelect = $('#customization_options')

  productSelect.on 'change', =>
    customSelect.html('<option></option>')
    url = urlTemplate.replace(/:product_id/, productSelect.val()) if productSelect.val()
    if url
      $.getJSON url, (data) =>
        console.log data
        $.each data, (index, el) =>
          customSelect.append "<option value='#{el.id}'>#{el.name}</option>"
        customSelect.trigger("chosen:updated")
    else
      customSelect.trigger("chosen:updated")
