$(".products.show").ready ->

  variantsSelector = {
    selected: { color: null, size: null }

    onColorClickHandler: (e) ->
      e.preventDefault()
      $(e.currentTarget).addClass('active').siblings().removeClass('active')
      color = $(e.currentTarget).data('color')
      variantsSelector.selectColor.call(variantsSelector, color)

    onSizeChangeHandler: (e) ->
      e.preventDefault()
      size = $(e.currentTarget).val()
      variantsSelector.selectSize.call(variantsSelector, size)

    selectColor: (color) ->
      @selected.color = color
      selected_variants = _.where(window.product_variants, { color: color })
      @updateSelectbox($('#toggle-selectbox'), selected_variants, 'size')
      @updateDeliveryTime()

    selectSize: (size) ->
      @selected.size = size
      @updateDeliveryTime()

    updateSelectbox: (container, available_options, method_name) ->
      return false # options update for 'chosen' plugin not working
      container.find('option').remove()
      container.append($('<option/>', { value: '', text: 'Select an Option' }))
      _.each(available_options, (option) ->
        container.append($('<option>', { value: option[method_name] }))
      )
      container.val(@selected.size)
      container.trigger("liszt:updated")

    updateDeliveryTime: () ->
      variant = @getSelectedVariant()
      return unless variant?

      if variant.fast_delivery
        deliveryText = '1-2 weeks delivery'
      else
        deliveryText = '3-4 weeks delivery'
      $('.price-delivery .delivery').text(deliveryText)

    getSelectedVariant: () ->
      variant = _.findWhere(window.product_variants, @selected)

    selectFirstAvailableOptions: () ->
      $(".colors-choser .colors .color:first").click()
      size = $('#toggle-selectbox option[value!=""]:first').attr('value')
      $('#toggle-selectbox').val(size)
      variantsSelector.selectSize(size)

  }

  if window.product_variants
    $(".colors-choser .colors .color:not(.active)").on('click', variantsSelector.onColorClickHandler)
    $('#toggle-selectbox').on('change', variantsSelector.onSizeChangeHandler)

    variantsSelector.selectFirstAvailableOptions()
