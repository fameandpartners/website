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
    @makingOptionsInput = new window.inputs.ProductMakingOptionIdSelector(options.making_options_input)

    @colorInput.on('change', @onChangeHandler)
    @sizeInput.on('change', @onChangeHandler)
    @customizationsInput.on('change', @onChangeHandler)
    @makingOptionsInput.on('change', @onChangeHandler)
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
      making_options_ids: @makingOptionsInput.val(),
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
