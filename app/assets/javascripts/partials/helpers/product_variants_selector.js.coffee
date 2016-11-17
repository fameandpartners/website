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
    @heightInput        = new window.inputs.ProductHeightSelector(options.height_input)

    @colorInput.on('change', @onChangeHandler)
    @sizeInput.on('change', @onChangeHandler)
    @customizationsInput.on('change', @onChangeHandler)
    @makingOptionsInput.on('change', @onChangeHandler)
    @heightInput.on(       'change', @onChangeHandler)

    # don't allow to select custom color & express making at the same time
    @colorInput.on('change', @updateMakingOptionsAvailablity)
    @makingOptionsInput.on('change', @updateCustomColorsAvailability)
    @

  onChangeHandler: (e) =>
    e.stopPropagation()
    @selected = null
    @trigger('change', @getValue())
    @updateDeliveryDate()

  updateDeliveryDate: () =>
    express    = $("#product-making-options-action").text().indexOf("Standard") == -1
    customized = $("#product-customize-action").text().indexOf("Customize") == -1
    $(".delivery-wrap-compact .date-text").hide()
    $(".delivery-wrap-compact #text_customize_express").show()     if express  and customized
    $(".delivery-wrap-compact #text_customize_standard").show()    if !express and customized
    $(".delivery-wrap-compact #text_no_customize_express").show()  if express  and !customized
    $(".delivery-wrap-compact #text_no_customize_standard").show() if !express and !customized

  # returns current value
  getValue: () ->
    @selected ||= @getCurrentSelection()

  getCurrentSelection: () ->
    selected = {
      size_id: @sizeInput.val(),
      color_id: @colorInput.val(),
      customizations_ids: @customizationsInput.val(),
      making_options_ids: @makingOptionsInput.val(),
      height:             @heightInput.val(),
      product_id: @product_id
    }

    # Don't attempt to specify a variant for invalid selections.
    return selected if @isInvalidSelection(selected)

    if @sizeInput.customValue() || @colorInput.customValue() || @customizationsInput.customValue() || @heightInput.customValue()
      selected.variant = @custom
    else
      selected.variant = _.findWhere(@variants, { size_id: selected.size_id, color_id: selected.color_id })

    selected.dress_variant = _.findWhere(@variants, { size_id: selected.size_id, color_id: selected.color_id })

    return selected

  isInvalidSelection: (selection) =>
    (!selection.size_id || !selection.color_id || !selection.height)

  updateCustomColorsAvailability: (e) =>
    e.preventDefault()
    if @makingOptionsInput.val()
      @colorInput.disableCustomColors()
    else
      @colorInput.enableCustomColors()

  updateMakingOptionsAvailablity: (e) =>
    e.preventDefault()
    if @colorInput.customValue()
      @makingOptionsInput.disable()
    else
      @makingOptionsInput.enable()

  # note: it should return errors statuses
  validate: () ->
    selected = @getValue()
    result = { valid: false }

    if selected.variant
      if selected.variant.available
        result.valid = true
      else
        result.error = 'Sorry babe, we\'re out of stock'
    else if @isInvalidSelection(selected)
      errorMessage = 'Please select a '

      missingValues = []
      missingValues.push('size')   if !selected.size_id
      missingValues.push('color')  if !selected.color_id
      # We present to customers as skirt length, but we are actually asking for customer height
      missingValues.push('skirt height') if !selected.height

      result.error = errorMessage + missingValues.join(' and ')
    else
      # we have size, color, but variant doesn't found
      result.error = 'Sorry babe, this combination is unavailable'

    result
