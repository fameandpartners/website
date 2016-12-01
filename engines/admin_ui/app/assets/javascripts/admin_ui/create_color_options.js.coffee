$ ->
  urlTemplate = '/fame_admin/customisation/product_colors/colors_options/:product_id'
  productSelect = $('#product_color_value_product_id')
  colorSelect = $('#product_color_value_option_value_id')

  productSelect.on 'change', =>
    colorSelect.html('<option></option>')
    url = urlTemplate.replace(/:product_id/, productSelect.val()) if productSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['product_colors'], (index, el) =>
          colorSelect.append "<option value='#{el.id}'>#{el.name}</option>"
        colorSelect.trigger("chosen:updated")
    else
      colorSelect.trigger("chosen:updated")

