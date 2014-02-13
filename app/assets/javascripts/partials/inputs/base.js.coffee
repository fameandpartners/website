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

window.inputs.ButtonsBoxSelector = class ButtonsBoxSelector extends BaseInput
  container: null
  buttons_selector: null

  constructor: (@container, @buttons_selector) ->
    super()
    _.bindAll(@, 'onButtonClickHandler')
    @container.on('click', @buttons_selector, @onButtonClickHandler)

  # private
  onButtonClickHandler: (e) ->
    e.preventDefault()
    $(e.target).siblings().removeClass('selected')
    $(e.target).addClass('selected')
    @trigger('change')

  getValue: () ->
    value = @container.find("#{@buttons_selector}.selected:first").data('size')
    if value
      return value
    else
      return null

  setValue: (newValue) ->
    selectedButton = @container.find("#{@buttons_selector}[data-size='#{ newValue }']")
    selectedButton.siblings().removeClass('selected').end().addClass('selected')
    return newValue

window.inputs.ChosenSelector = class ChosenSelector extends BaseInput
  constructor: (@container) ->
    super()
    _.bindAll(@, 'onValueChanged')
    @container.on('change', @onValueChanged)

  onValueChanged: (e) ->
    @trigger('change')

  getValue: () ->
    value = @container.val()
    if value then value else null

  setValue: (newValue) ->
    @container.val(newValue).trigger('chosen:updated')
