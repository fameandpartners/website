# element to manage product selection
#   - size
#   - color
#   - customizations
# output
#   - currently selected element
#   - event 'change'
#   - errors
#
window.helpers or= {}

window.helpers.ProductVariantsSelector = class ProductVariantsSelector
  constructor: (options = {}) ->
    # event bus mechanics
    @$eventBus  = $({})
    @trigger    =  delegateTo(@$eventBus, 'trigger')
    @on         =  delegateTo(@$eventBus, 'on')

    @$container = $(options.container)
    @product_id = options.product_id
    @custom   = { id: options.custom_id, product_id: @product_id, count_on_hand: 0, fast_delivery: false, available: true }
    @variants = options.variants

    @sizeInput = new window.inputs.ProductSizeIdSelector(options.size_input)
    @colorInput = new window.inputs.ProductColorIdSelector(options.color_input)
    @customizationsInput = new window.inputs.ProductCustomizationIdsSelector(options.customization_input)

    @colorInput.on('change', @onChangeHandler)
    @sizeInput.on('change', @onChangeHandler)
    @customizationsInput.on('change', @onChangeHandler)
    @

  onChangeHandler: (e) =>
    e.stopPropagation()
    @selected = null
    @trigger('change', @getValue())

  # returns current value
  getValue: () ->
    @selected ||= @getCurrentSelection()

  getCurrentSelection: () ->
    selected = {
      size_id: @sizeInput.val(),
      color_id: @colorInput.val(),
      customizations_ids: @customizationsInput.val(),
      product_id: @product_id
    }

    # if user don't selected size & color, then do nothing.
    return selected if (!selected.size_id || !selected.color_id)

    if @sizeInput.customValue() || @colorInput.customValue() || @customizationsInput.customValue()
      selected.variant = @custom
    else
      selected.variant = _.findWhere(@variants, { size_id: selected.size_id, color_id: selected.color_id })

    return selected

  # note: it should return errors statuses
  validate: () ->
    selected = @getValue()
    result = { valid: false }

    if selected.variant
      if selected.variant.available
        result.valid = true
      else
        result.error = 'Sorry babe, we\'re out of stock'
    else if _.isEmpty(selected.size_id) && _.isEmpty(selected.color_id)
      result.error = 'Please select a size and color'
    else if _.isEmpty(selected.size_id)
      result.error = 'Please select a size'
    else if _.isEmpty(selected.color_id)
      result.error = 'Please select a color'
    else
      # we have size, color, but variant doesn't found
      result.error = 'Sorry babe, this combination is unavailable'

    result

#      target_data = { id: null, error: null }
#
#      if ! _.isEmpty(variant)
#        if variant.available
#          target_data.id = variant.id
#        else
#          window.helpers.showErrors(@target.parent(), 'Sorry, out of stock')
#          target_data.error = 'Sorry, out of stock'
#      else if _.isNull(variantsSelector.selected.size)
#        target_data.error = 'Please select a size'
#      else if _.isEmpty(variantsSelector.selected.color)
#        target_data.error = 'Please select a colour'
#      else if !_.isEmpty(variantsSelector.selected.color) && ! _.isNull(variantsSelector.selected.size)
#        target_data.error = 'Sorry, this combination unavailable'
#      else
#        target_data.error = 'Please, select size and colour'


#window.helpers.createProductVariantsSelector = (root, variants, preselected {}) ->
#  variantsSelector = {
#    selected:   {
#      color_id: null,
#      size_id:  null,
#      customizations_ids: []
#    }
#    variants:   null
#    container:  $(root)
#    target:     null
#    sizeInput:  null
#    colorInput: null
#    customizationsInput: null
#
#    init: () ->
#      variantsSelector.__init.apply(variantsSelector, arguments)
#      return variantsSelector
#
#    __init: (variants, preselected) ->
#      _.bindAll(@, 'onVariantsChanged')
#
#      @variants = variants
#
#      @sizeInput  or= new inputs.ButtonsBoxSelector(@container.find('.section .sizebox'), '.button')
#      @colorInput or= new inputs.ChosenSelector(@container.find('select#colour'))
#
#      @sizeInput.on('change',  @onVariantsChanged)
#      @colorInput.on('change', @onVariantsChanged)
#
#      window.sizeInput = @sizeInput
#
#      if window.shopping_cart
#        window.shopping_cart.on('item_added',   @onVariantsChanged)
#        window.shopping_cart.on('item_removed', @onVariantsChanged)
#
#        if preselected
#          @setPreselectedValues(preselected)
#        else
#          if @colorInput.val() || @sizeInput.val()
#            @onVariantsChanged()
#
#            return @
#

#window.helpers.createProductVariantsSelector = (root) ->
#  rootElement = root
#  variantsSelector = {
#    selected:   { color: null, size: null }
#    variants:   null
#    container:  root
#    target:     null
#    sizeInput:  null
#    colorInput: null
#
#    init: () ->
#      variantsSelector.__init.apply(variantsSelector, arguments)
#      return variantsSelector
#
#    __init: (variants, preselected) ->
#      _.bindAll(@, 'onVariantsChanged')
#      @variants = variants
#      @target or= rootElement.find('.section .btn.buy-now')
#
#      @sizeInput  or= new inputs.ButtonsBoxSelector(@container.find('.section .sizebox'), '.button')
#      @colorInput or= new inputs.ChosenSelector(@container.find('select#colour'))
#
#      @sizeInput.on('change',  @onVariantsChanged)
#      @colorInput.on('change', @onVariantsChanged)
#      window.sizeInput = @sizeInput
#
#      if window.shopping_cart
#        window.shopping_cart.on('item_added',   @onVariantsChanged)
#        window.shopping_cart.on('item_removed', @onVariantsChanged)
#
#      if preselected
#        @setPreselectedValues(preselected)
#      else
#        if @colorInput.val() || @sizeInput.val()
#          @onVariantsChanged()
#
#      return @
#
#    exportSelectedVariant: (variant) ->
#      target_data = { id: null, error: null }
#
#      if ! _.isEmpty(variant)
#        if variant.available
#          target_data.id = variant.id
#        else
#          window.helpers.showErrors(@target.parent(), 'Sorry, out of stock')
#          target_data.error = 'Sorry, out of stock'
#      else if _.isNull(variantsSelector.selected.size)
#        target_data.error = 'Please select a size'
#      else if _.isEmpty(variantsSelector.selected.color)
#        target_data.error = 'Please select a colour'
#      else if !_.isEmpty(variantsSelector.selected.color) && ! _.isNull(variantsSelector.selected.size)
#        target_data.error = 'Sorry, this combination unavailable'
#      else
#        target_data.error = 'Please, select size and colour'
#
#      @target.data(target_data)
#      variant
#
#    updateSizeInputStockAvailability: (selected) ->
#      return unless _.isFunction(@sizeInput.disableSelectionOptions)
#      unavailable_options = []
#      if !_.isEmpty(selected) and !_.isNull(selected.color)
#        unavailable_variants = _.where(@variants, { color: selected.color, available: false })
#        unavailable_options = _.pluck(unavailable_variants, 'size')
#      @sizeInput.disableSelectionOptions(unavailable_options, 'SOLD OUT')
#
#    setPreselectedValues: (preselected) ->
#      variant = _.findWhere(@variants, preselected)
#      if variant
#        @colorInput.val(variant.color)
#        @sizeInput.val(variant.size)
#        @onVariantsChanged()
#
#    onVariantsChanged: () ->
#      @selected = {
#        color: @colorInput.val(),
#        size: @sizeInput.val()
#      }
#      @container.trigger('selection_changed', @selected)
#      @container.data('selected', @selected)
#      @updateSizeInputStockAvailability(@selected)
#      @exportSelectedVariant(@getSelectedVariant())
#
#    getSelectedVariant: () ->
#      variant = _.findWhere(@variants, @selected)
#      #if variant and window.shopping_cart
#      #  line_item = _.find(window.shopping_cart.line_items, (line_item) -> line_item.variant_id == variant.id)
#      #  variant.purchased = !!line_item
#      #  variant
#      #else
#      #  {}
#      return variant
#  }
#
#window.helpers.createProductVariantsSelector = (root) ->
#  rootElement = root
#
#  variantsSelector = {
#    selected: { color: null, size: null },
#    variants: null,
#    container: root,
#
#    init: (variants, selected) ->
#      variantsSelector.variants = variants
#      rootElement.find(".colors-choser .colors .color:not(.active)").on('click', variantsSelector.onColorClickHandler)
#      $hoverPopup = $('<div />', class: 'color-image-popup').html('<img />')
#      $hoverPopup.appendTo($('body'))
#
#      rootElement.find(".colors-choser .colors .color[data-image]").on 'mouseenter', ->
#        if $(this).data('image').length
#          $hoverPopup.find('img').prop('src', $(this).data('image'))
#          $hoverPopup.stop(true, false).animate(opacity: 1, 'fast').css(left: $(this).offset().left-($hoverPopup.outerWidth() - $(this).outerWidth())/2, top: $(this).offset().top - ($hoverPopup.outerHeight() + 5))
#      rootElement.find(".colors-choser .colors .color[data-image]").on 'mouseleave', ->
#        $hoverPopup.stop(true, false).animate(opacity: 0, 'fast')
#
#
#      rootElement.find('#toggle-selectbox').on('change', variantsSelector.onSizeChangeHandler)
#      variantsSelector.preselectSize()
#      variantsSelector.selectOptions.call(variantsSelector, selected)
#      rootElement.find('#toggle-selectbox').chosen()
#      rootElement.find('.selectbox').chosen()
#
#      if window.shopping_cart
#        window.shopping_cart.on('item_added',   variantsSelector.cartItemsChangedHandler)
#        window.shopping_cart.on('item_removed', variantsSelector.cartItemsChangedHandler)
#
#      return variantsSelector
#
#    preselectSize: () ->
#      if rootElement.find('#toggle-selectbox option[value=""]').length > 0
#        variantsSelector.selected.size = null
#        newSize = ''
#      else
#        newSize = rootElement.find('#toggle-selectbox option:first').val()
#        variantsSelector.selected.size = newSize
#
#      rootElement.find('#toggle-selectbox').val(newSize)
#
#    onColorClickHandler: (e) ->
#      e.preventDefault()
#      $(e.currentTarget).addClass('active').siblings().removeClass('active')
#      color = $(e.currentTarget).data('color')
#      variantsSelector.selectColor.call(variantsSelector, color)
#
#    onSizeChangeHandler: (e) ->
#      e.preventDefault()
#      size = $(e.currentTarget).val()
#      variantsSelector.selectSize.call(variantsSelector, size)
#
#    cartItemsChangedHandler: (e, data) ->
#      variantsSelector.onVariantsChanged.call(variantsSelector)
#
#    selectColor: (color) ->
#      @selected.color = color
#      avaialable_variants = _.where(@variants, { color: color })
#      @updateSelectbox(rootElement.find('#toggle-selectbox'), avaialable_variants, 'size')
#      @onVariantsChanged()
#
#    selectSize: (size) ->
#      @selected.size = size
#      @onVariantsChanged()
#
#      if !!size
#        avaialable_variants = _.where(@variants, { size: size })
#      else
#        avaialable_variants = @variants
#      @updateColorsSelector(avaialable_variants)
#
#    onVariantsChanged: () ->
#      window.initProductImagesCarousel(@selected) if window.initProductImagesCarousel
#
#      variant = @getSelectedVariant()
#
#      @exportSelectedVariant(variant)
#      @updateItemAvailability(variant)
#
#      if ! _.isEmpty(variant)
#        $button = rootElement.find('.buy-wishlist .buy-now')
#        $button.trigger('variant_selected', variant)
#
#    updateSelectbox: (selectBox, available_options, method_name) ->
#      selectBox.find("option[value!='']").attr('disabled', 'disabled').removeClass('unavailable')
#
#      _.each(available_options, (variant) ->
#        selectOption = selectBox.find("option[value=#{variant.size}]")
#        selectOption.removeAttr('disabled')
#        if !variant.available
#          selectOption.addClass('unavailable')
#          selectOption.html("<span style='text-decoration: line-through;'>#{variant.size} SOLD OUT</span>")
#        else
#          selectOption.text(variant.size)
#        selectOption.addClass('unavailable')
#      )
#
#      selectBox.trigger("liszt:updated")
#
#    updateColorsSelector: (avaialable_variants) ->
#      $('.colors-choser .colors .color').hide()
#      _.each(avaialable_variants, (variant) ->
#        $(".colors-choser .colors .color[data-color='#{variant.color}']").show()
#      )
#      return
#
#    exportSelectedVariant: (variant) ->
#      # update buttons
#      $button = rootElement.find('.buy-wishlist .buy-now')
#      $wishlist_button = rootElement.find('.buy-wishlist .add-wishlist')
#      $selectedSize = rootElement.find('#toggle_selectbox_chzn a.chzn-single').removeClass('unavailable')
#
#      if ! _.isEmpty(variant)
#        if variant.available
#          $button.data(id: variant.id, error: null)
#          $wishlist_button.data(id: variant.id)
#          if variant.purchased
#            $button.addClass('added')
#          else
#            $button.removeClass('added')
#            # don't change master variant data, if product don't have variants
#        else
#          $button.removeClass('added')
#          $button.data(id: null, error: 'Sorry, this item is out of stock')
#          window.helpers.showErrors(rootElement.find('.size-select'), 'Sorry, out of stock')
#          $selectedSize.addClass('unavailable')
#      else if @variants? && @variants.length > 0
#        $button.removeClass('added')
#        $button.data(id: null, error: 'Please, select size and colour')
#
#    getSelectedVariant: () ->
#      variant = _.findWhere(@variants, @selected)
#      if variant and window.shopping_cart
#        line_item = _.find(window.shopping_cart.line_items, (line_item) -> line_item.variant_id == variant.id)
#        variant.purchased = !!line_item
#        variant
#      else
#        {}
#
#    updateItemAvailability: (variant) ->
#      $button = rootElement.find('.buy-wishlist .buy-now')
#
#      if variant and variant.available
#        $button.removeAttr('disabled').removeClass('out-of-stock')
#      else
#        $button.attr('disabled', true).addClass('out-of-stock')
#
#    selectOptions: (selected) ->
#      if selected
#        variant = _.findWhere(@variants, { id: selected.id })
#        variant or= _.findWhere(@variants, selected)
#        variant or= _.findWhere(@variant, { color: selected.color })
#        variant or= _.findWhere(@variant, { size: selected.size })
#
#      if variant
#        variantsSelector.selectSizeAndColor(variant.size, variant.color)
#
#    selectSizeAndColor: (size, color) ->
#      rootElement.find('#toggle-selectbox').val(size).trigger("liszt:updated")
#      rootElement.find(".colors-choser .colors .color.#{color}").click()
#
#      variantsSelector.selectSize.call(variantsSelector, size)
#  }
