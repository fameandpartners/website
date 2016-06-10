$ ->
  styleSelect = $('#forms_manual_order_style_name')

  colorUrl = '/fame_admin/manual_orders/colors/:product_id'
  colorSelect = $('#forms_manual_order_color')

  sizeUrl = '/fame_admin/manual_orders/sizes/:product_id'
  sizeSelect = $('#forms_manual_order_size')

  customisationUrl = '/fame_admin/manual_orders/customisations/:product_id'
  customisationSelect = $('#forms_manual_order_customisations')

  styleSelect.on 'change', =>
    colorSelect.html('<option></option>')
    url = colorUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          colorSelect.append "<option value='#{el.id}'>#{el.name}</option>"
        colorSelect.trigger("chosen:updated")
    else
      colorSelect.trigger("chosen:updated")

    sizeSelect.html('<option></option>')
    url = sizeUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          sizeSelect.append "<option value='#{el.id}'>#{el.name}</option>"
        sizeSelect.trigger("chosen:updated")
    else
      sizeSelect.trigger("chosen:updated")

    customisationSelect.html('<option></option>')
    url = customisationUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          customisationSelect.append "<option value='#{el.id}'>#{el.name}</option>"
        customisationSelect.trigger("chosen:updated")
    else
      customisationSelect.trigger("chosen:updated")
