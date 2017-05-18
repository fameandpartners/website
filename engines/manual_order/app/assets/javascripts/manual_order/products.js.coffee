$ ->

  # TODO: replace inline paths with rails routes (in the admin_ui as well)

  styleSelect = $('#forms_manual_order_style_name')

  colorUrl = '/fame_admin/manual_orders/colors/:product_id'
  colorSelect = $('#forms_manual_order_color')

  optColors = $('<optgroup>').attr('label', "Colors")
  optCustomColors = $('<optgroup>').attr('label', "Custom Colors + $16.00")

  sizeUrl = '/fame_admin/manual_orders/sizes/:product_id'
  heightUrl = '/fame_admin/manual_orders/heights/:product_id'
  sizeSelect = $('#forms_manual_order_size')
  heightSelect = $('#forms_manual_order_height')

  customisationUrl = '/fame_admin/manual_orders/customisations/:product_id'
  customisationSelect = $('#forms_manual_order_customisations')

  imageUrl = '/fame_admin/manual_orders/images/:product_id/:color_id'
  imageTag = $('h4.product_image')

  priceUrl = '/fame_admin/manual_orders/prices/:product_id/:currency'
  priceTag = $('h4.price')

  adjustButtonPanel = $('.adjust-btn-panel')
  adjustButton = $('.adjust-btn', adjustButtonPanel)
  adjustPanel = $('.adjust-panel')
  adjustPanelAmount = $('.amount', adjustPanel)
  adjustPanelDescription = $('.description', adjustPanel)
  adjustPanelOKButton = $('.ok-button', adjustPanel)
  submitButton = $('.submit_btn')

  currencySelect = $('#forms_manual_order_currency')

  clearAll = ->
    colorSelect.html('<option></option>')
    optColors.html('')
    optCustomColors.html('')
    sizeSelect.html('<option></option>')
    heightSelect.html('<option></option>')
    customisationSelect.html('<option></option>')
    imageTag.html('Please select style and color to see image')
    priceTag.html('Please select product details')
    adjustButtonPanel.hide()
    adjustPanel.hide()
    adjustPanelAmount.val('')
    adjustPanelDescription.val('')

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
        sizeSelect.trigger("chosen:updated")
    else
      sizeSelect.trigger("chosen:updated")

  updateHeights = ->
    if styleSelect.val()
      url = heightUrl.replace(/:product_id/, styleSelect.val())
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          heightSelect.append $('<option>').attr('value', el.id).text(el.name)
        heightSelect.trigger("chosen:updated")
    else
      heightSelect.trigger("chosen:updated")

  updatePrice = ->
    url = priceUrl.replace(/:product_id/, styleSelect.val())
    .replace(/:currency/, currencySelect.val())
    $.getJSON url, (data) =>
      priceTag.html("$#{data.price} #{data.currency}")
      adjustButtonPanel.show()

  updateCustomisations = ->
    url = customisationUrl.replace(/:product_id/, styleSelect.val()) if styleSelect.val()
    if url
      $.getJSON url, (data) =>
        $.each data['manual_orders'], (index, el) =>
          customisationSelect.append option = $('<option>').attr('value', el.id).text(el.name)
        customisationSelect.trigger("chosen:updated")
    else
      customisationSelect.trigger("chosen:updated")

  updateImage = ->
    url = imageUrl.replace(/:product_id/, styleSelect.val())
    .replace(/:color_id/, colorSelect.val())
    $.getJSON url, (data) =>
      if data.url isnt 'null'
        image = $('<img>').attr('src', data.url)
        imageTag.html(image)

  styleSelect.on 'change', =>
    clearAll()
    updateColors()
    updateSizes()
    updateHeights()
    updateCustomisations()

  colorSelect.on 'change', =>
    if colorSelect.val()
      updateImage()
      updatePrice()

  currencySelect.on 'change', =>
    if colorSelect.val()
      updatePrice()

  adjustButton.on 'click', =>
    adjustPanel.show()
    adjustPanelAmount.prop('readonly', false);
    adjustPanelDescription.prop('readonly', false);
    adjustPanelOKButton.show()
    adjustButton.hide()
    submitButton.prop('disabled', true)

  adjustPanelOKButton.on 'click', =>
    if !$.trim(adjustPanelAmount.val()).length && !$.trim(adjustPanelDescription.val()).length
      adjustButton.show()
      adjustPanelOKButton.hide()
      adjustPanel.hide()
      submitButton.prop('disabled', false)
    else if !$.isNumeric( adjustPanelAmount.val() ) || !$.trim(adjustPanelDescription.val()).length
      alert('Please input correct amount value and description')
      return false
    else
      adjustButton.show()
      adjustPanelOKButton.hide()
      adjustPanelAmount.prop('readonly', true);
      adjustPanelDescription.prop('readonly', true);
      submitButton.prop('disabled', false)

