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
      rootElement.find('.selectbox').chosen()

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
      avaialable_variants = _.where(@variants, { color: color })
      @updateSelectbox(rootElement.find('#toggle-selectbox'), avaialable_variants, 'size')
      @updatePurchaseConditions()

    selectSize: (size) ->
      @selected.size = size
      @updatePurchaseConditions()

      if !!size
        avaialable_variants = _.where(@variants, { size: size })
      else
        avaialable_variants = @variants
      @updateColorsSelector(avaialable_variants)

    updateSelectbox: (selectBox, available_options, method_name) ->
      selectBox.find('option').attr('disabled', 'disabled')

      _.each(available_options, (variant) ->
        selectBox.find("option[value=#{variant.size}]").removeAttr('disabled')
      )
      selectBox.find("option[value='']").removeAttr('disabled')

      selectBox.trigger("liszt:updated")

    updateColorsSelector: (avaialable_variants) ->
      $('.colors-choser .colors .color').hide()
      _.each(avaialable_variants, (variant) ->
        $(".colors-choser .colors .color[data-color='#{variant.color}']").show()
      )
      return

    updatePurchaseConditions: () ->
      @updateDeliveryTime()
      # update buttons
      variant = @getSelectedVariant()
      $button = rootElement.find('.buy-wishlist .buy-now')
      $wishlist_button = rootElement.find('.buy-wishlist .add-wishlist')
      if ! _.isEmpty(variant)
        $button.data(id: variant.id)
        $wishlist_button.data(id: variant.id)
        if variant.purchased
          $button.addClass('added')
        else
          $button.removeClass('added')
          # don't change master variant data, if product don't have variants
      else if @variants? && @variants.length > 0
        $button.removeClass('added')
        $button.data(id: null)

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
        variant or= _.findWhere(@variant, { color: selected.color })
        variant or= _.findWhere(@variant, { size: selected.size })

      variant or= @variants[0]
      if variant
        variantsSelector.selectSizeAndColor(variant.size, variant.color)

    selectSizeAndColor: (size, color) ->
      rootElement.find('#toggle-selectbox').val(size).trigger("liszt:updated")
      rootElement.find(".colors-choser .colors .color.#{color}").click()

      variantsSelector.selectSize.call(variantsSelector, size)
  }
