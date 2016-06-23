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

  imageUrl = '/fame_admin/manual_orders/images/:product_id/:size_id/:color_id'
  imageTag = $('h4.product_image')

  priceUrl = '/fame_admin/manual_orders/prices/:product_id/:size_id/:color_id/:currency'
  priceTag = $('h4.price')

  siteVersionSelect = $('#forms_manual_order_site_version')

  clearAll = ->
    colorSelect.html('<option></option>')
    optColors.html('')
    optCustomColors.html('')
    sizeSelect.html('<option></option>')
    customisationSelect.html('<option></option>')
    imageTag.html('Please select style, size and color to see image')
    priceTag.html('Please select product details')

  updateColors = ->
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

  updateSizes = ->
    url = sizeUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          sizeSelect.append $('<option>').attr('value', el.id).text(el.name)
        sizeSelect.append $('<option>').attr('value', 'custom').text('Custom')
        sizeSelect.trigger("chosen:updated")
    else
      sizeSelect.trigger("chosen:updated")

  updatePrice = ->
    url = priceUrl.replace(/:product_id/, styleSelect.val())
    .replace(/:size_id/, sizeSelect.val())
    .replace(/:color_id/, colorSelect.val())
    .replace(/:currency/, siteVersionSelect.val())
    $.getJSON url, (data) =>
      priceTag.html("$#{data.price} #{data.currency}")

  updateCustomisations = ->
    url = customisationUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          customisationSelect.append option = $('<option>').attr('value', el.id).text(el.name)
        customisationSelect.append $('<option>').attr('value', 'custom').text('Custom')
        customisationSelect.trigger("chosen:updated")
    else
      customisationSelect.trigger("chosen:updated")

  updateImage = ->
    url = imageUrl.replace(/:product_id/, styleSelect.val())
    .replace(/:size_id/, sizeSelect.val())
    .replace(/:color_id/, colorSelect.val())
    $.getJSON url, (data) =>
      if data.url isnt 'null'
        image = $('<img>').attr('src', data.url)
        imageTag.html(image)

  styleSelect.on 'change', =>
    clearAll()
    updateColors()
    updateSizes()
    updateCustomisations()

  colorSelect.on 'change', =>
    if sizeSelect.val() and colorSelect.val()
      updateImage()
      updatePrice()

  siteVersionSelect.on 'change', =>
    if sizeSelect.val() and colorSelect.val()
      updatePrice()




