# note:
#   purpose of inputs - providing the same interface for all inputs, regardless of external lib
#   for easier development and changing libs. or
#
#   base interface:
#     input = new inputs.MyInput({ container: '-', valueType: '', value: '' })
#     input.on('change', callback)
#     input.val()
#     input.setVal()
#
window.inputs or= {}

window.inputs.BaseInput = class BaseInput
  constructor: (options = {}) ->
    @$el = $(options.container)
    @valueType = options.valueType || 'string'
    @listeners = {}
    if !!options.value
      @val(options.value)

  getValue: () -> console.log('get value func is not defined')
  setValue: () -> console.log('set value func is not defined')

  val: (newValue) ->
    if arguments.length == 0
      @getValue()
    else
      @setValue(newValue)
      return newValue

  on: (eventName, callback) ->
    @listeners[eventName] or= []
    @listeners[eventName].push(callback)

  trigger: (eventName) ->
    callbacks = @listeners[eventName] || []
    for callback in callbacks
      callback()

  prepareValue: (value) ->
    if _.isUndefined(value)
      return null
    else if @valueType == 'integer'
      parseInt(value)
    else
      value

window.inputs.Select2Selector = class Select2Selector extends BaseInput
  constructor: (options = {}) ->
    super(options)
    _.bindAll(@, 'onValueChanged')
    @$el.select2()
    @$el.on('change', @onValueChanged)

  onValueChanged: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @trigger('change')

  getValue: () ->
    @prepareValue(@$el.val())

  setValue: (newValue) ->
    @$el.val(@prepareValue(newValue))
    @onValueChanged()

window.inputs.Select2MultiSelector = class Select2MultiSelector extends Select2Selector
  constructor: (options = {}) ->
    options.value ||= []
    super(options)

  getValue: () ->
    val = super()
    if val
      [val]
    else
      []
# eo of base classes

# generic classes.
window.inputs.ProductSizeIdSelector = class ProductSizeIdSelector extends Select2Selector
  constructor: (options = {}) ->
    options.valueType = 'integer'
    super(options)

  customValue: () ->
    @$el.find("option[value=#{ @val() }]").data('custom')

window.inputs.ProductColorIdSelector = class ProductColorIdSelector extends Select2Selector
  constructor: (options = {}) ->
    options.valueType = 'integer'
    super(options)

  customValue: () ->
    @$el.find("option[value=#{ @val() }]").data('custom')

window.inputs.ProductCustomizationsIdsSelector = class ProductCustomizationsIdsSelector extends BaseInput
  constructor: (options = {}) ->
    options.valueType = 'integer'
    super(options)

  getValue: () ->
    @prepareValue(@$el.val())

  setValue: (newValue) ->
    @$el.val(@prepareValue(newValue))
    @onValueChanged()

  customValue: () ->
    @$el.find("option[value=#{ @val() }]").data('custom')


window.inputs.BaseTextSelector = class BaseTextSelector extends Select2Selector
  constructor: (options = {}) ->
    options.valueType = 'string'
    super(options)

window.inputs.ProductColorNameSelector  = class ProductColorNameSelector extends BaseTextSelector
window.inputs.ProductBodyShapeSelector  = class ProductBodyShapeSelector extends BaseTextSelector
window.inputs.ProductStyleNameSelector  = class ProductStyleNameSelector extends BaseTextSelector
window.inputs.ProductOrderSelector      = class ProductOrderSelector extends BaseTextSelector

#window.inputs.FxSelector = class FxSelector extends BaseInput
#  constructor: (scope, element, preselected = null) ->
#    super()
#    _.bindAll(@, 'onValueChanged')
#
#    @$el = scope.find(element)
#    @select = new SelectFx(@$el[0], onChange: @onValueChanged)
#
#  onValueChanged: (newValue) ->
#    #@$el.onchange() # SelectFx doesn't trigger it by itself
#    @trigger('change')
#
#  getValue: () ->
#    raw = @$el.val()
#    if raw
#      parseInt(raw)
#    else
#      null
#
#  customValue: () ->
#    value = @$el.val()
#    @$el.find("option[value=#{ value }]").data('custom')
#
#  setValue: (newValue) ->
#    @select.selectedOpt = @$el.find("option[value=#{ newValue }]")[0]
#    @select._changeOption()
#
#window.inputs.MultiFxSelector = class MultiFxSelector extends FxSelector
#  getValue: () ->
#    val = super()
#    if val
#      [val]
#    else
#      []
