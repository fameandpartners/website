window.helpers or= {}

window.helpers.createProductVariantsSelector = (root) ->
  rootElement = root

  variantsSelector = {
    selected: { color: null, size: null },
    variants: null,

    init: (variants) ->
      rootElement.find('#toggle-selectbox').chosen()
      variantsSelector.variants = variants
      rootElement.find(".colors-choser .colors .color:not(.active)").on('click', variantsSelector.onColorClickHandler)
      rootElement.find('#toggle-selectbox').on('change', variantsSelector.onSizeChangeHandler)
      variantsSelector.selectFirstAvailableOptions()
      return variantsSelector

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
      selected_variants = _.where(@variants, { color: color })
      @updateSelectbox(rootElement.find('#toggle-selectbox'), selected_variants, 'size')
      @updatePurchaseConditions()

    selectSize: (size) ->
      @selected.size = size
      @updatePurchaseConditions()

    updateSelectbox: (container, available_options, method_name) ->
      return false # options update for 'chosen' plugin not working
      container.find('option').remove()
      container.append($('<option/>', { value: '', text: 'Select an Option' }))
      _.each(available_options, (option) ->
        container.append($('<option>', { value: option[method_name] }))
      )
      container.val(@selected.size)
      container.trigger("liszt:updated")

    updatePurchaseConditions: () ->
      @updateDeliveryTime()
      # update buttons
      variant = @getSelectedVariant()
      $button = rootElement.find('.buy-wishlist .buy-now')
      if variant
        $button.data(variant_id: variant.id)
        if variant.purchased
          $button.addClass('purchased')
        else
          $button.removeClass('purchased')
      else
        $button.removeClass('purchased')
        $button.data(variant_id: null)

    updateDeliveryTime: () ->
      variant = @getSelectedVariant()
      return unless variant?

      if variant.fast_delivery
        deliveryText = '1-2 weeks delivery'
      else
        deliveryText = '3-4 weeks delivery'
      rootElement.find('.price-delivery .delivery').text(deliveryText)

    getSelectedVariant: () ->
      variant = _.findWhere(@variants, @selected)
      if variant
        line_item = _.find(window.items_in_cart, (item_in_cart) -> item_in_cart == variant.id)
        variant.in_cart = !!line_item
        variant
      else
        {}

    selectFirstAvailableOptions: () ->
      rootElement.find(".colors-choser .colors .color:first").click()
      size = rootElement.find('#toggle-selectbox option[value!=""]:first').attr('value')
      rootElement.find('#toggle-selectbox').val(size)
      variantsSelector.selectSize(size)
  }
