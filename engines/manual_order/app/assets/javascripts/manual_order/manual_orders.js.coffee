$ ->
  styleSelect = $('#forms_manual_order_style_name')

  colorUrl = '/fame_admin/manual_orders/colors/:product_id'
  colorSelect = $('#forms_manual_order_color')
  optColors = $('<optgroup>').attr('label', "Colors")
  optCustomColors = $('<optgroup>').attr('label', "Custom Colors + $16.00")

  sizeUrl = '/fame_admin/manual_orders/sizes/:product_id'
  sizeSelect = $('#forms_manual_order_size')

  customisationUrl = '/fame_admin/manual_orders/customisations/:product_id'
  customisationSelect = $('#forms_manual_order_customisations')

  styleSelect.on 'change', =>
    colorSelect.html('<option></option>')
    optColors.html('')
    optCustomColors.html('')
    url = colorUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        optColors.appendTo colorSelect
        optCustomColors.appendTo colorSelect
        $.each data['manual_orders'], (index, el) =>
          option = $('<option>').attr('value', el.id).text(el.name)
          if el.type == 'color' then option.appendTo optColors else option.appendTo optCustomColors
        colorSelect.trigger("chosen:updated")
    else
      colorSelect.trigger("chosen:updated")

    sizeSelect.html('<option></option>')
    url = sizeUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          sizeSelect.append $('<option>').attr('value', el.id).text(el.name)
        sizeSelect.trigger("chosen:updated")
    else
      sizeSelect.trigger("chosen:updated")

    customisationSelect.html('<option></option>')
    url = customisationUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          customisationSelect.append option = $('<option>').attr('value', el.id).text(el.name)
        customisationSelect.trigger("chosen:updated")
    else
      customisationSelect.trigger("chosen:updated")
