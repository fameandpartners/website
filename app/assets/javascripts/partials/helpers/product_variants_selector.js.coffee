window.helpers or= {}

window.helpers.createProductVariantsSelector = (root) ->
  rootElement = root

  variantsSelector = {
    selected: { color: null, size: null },
    variants: null,

    init: (variants, selected) ->
      variantsSelector.variants = variants
      rootElement.find(".colors-choser .colors .color:not(.active)").on('click', variantsSelector.onColorClickHandler)
      rootElement.find('#toggle-selectbox').on('change', variantsSelector.onSizeChangeHandler)
      variantsSelector.selectOptions.call(variantsSelector, selected)
      rootElement.find('#toggle-selectbox').chosen()

      if window.shopping_cart
        window.shopping_cart.on('item_added',   variantsSelector.cartItemsChangedHandler)
        window.shopping_cart.on('item_removed', variantsSelector.cartItemsChangedHandler)

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

    cartItemsChangedHandler: (e, data) ->
      variantsSelector.updatePurchaseConditions.call(variantsSelector)

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
      rootElement.find('.delivery').text(deliveryText)

    getSelectedVariant: () ->
      variant = _.findWhere(@variants, @selected)
      if variant and window.shopping_cart
        line_item = _.find(window.shopping_cart.line_items, (line_item) -> line_item.variant_id == variant.id)
        variant.purchased = !!line_item
        variant
      else
        {}

    selectOptions: (selected) ->
      if selected
        variant = _.findWhere(@variants, { id: selected.id })
        variant or= _.findWhere(@variants, selected)

      if variant
        variantsSelector.selectSizeAndColor(variant.size, variant.color)
      else
        variantsSelector.selectFirstAvailableOptions()

    selectFirstAvailableOptions: () ->
      variant = variantsSelector.variants[0]
      variantsSelector.selectSizeAndColor(variant.size, variant.color)

    selectSizeAndColor: (size, color) ->
      rootElement.find(".colors-choser .colors .color.#{color}").click()
      rootElement.find('#toggle-selectbox').val(size)
      variantsSelector.selectSize.call(variantsSelector, size)
  }
