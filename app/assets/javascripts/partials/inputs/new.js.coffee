# todo: rename this file
#
window.inputs or= {}

window.inputs.BaseInput = class BaseInput
  constructor: () ->
    @listeners = {}

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

  getValue: () -> console.log('get value func is not defined')
  setValue: () -> console.log('set value func is not defined')


window.inputs.FxSelector = class FxSelector extends BaseInput
  constructor: (scope, element, preselected = null) ->
    super()
    _.bindAll(@, 'onValueChanged')

    @$el = scope.find(element)
    @select = new SelectFx(@$el[0], onChange: @onValueChanged)

  onValueChanged: (newValue) ->
    #@$el.onchange() # SelectFx doesn't trigger it by itself
    @trigger('change')

  getValue: () ->
    raw = @$el.val()
    if raw
      parseInt(raw)
    else
      null

  customValue: () ->
    value = @$el.val()
    @$el.find("option[value=#{ value }]").data('custom')

  setValue: (newValue) ->
    @select.selectedOpt = @$el.find("option[value=#{ newValue }]")[0]
    @select._changeOption()

window.inputs.MultiFxSelector = class MultiFxSelector extends FxSelector
  getValue: () ->
    val = super()
    if val
      [val]
    else
      []
