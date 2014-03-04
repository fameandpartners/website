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

    if !_.isUndefined(value)
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


window.inputs.CustomAndBaseColourSelector = class CustomAndBaseColourSelector extends BaseInput
  # note: all inputs should have unique id to separate them from each other
  constructor: (@baseColourInput, @customColourInput) ->
    super()
    _.bindAll(@, 'onValueSelectedHandler')
    @baseColourInput.on('change', @onValueSelectedHandler)
    @customColourInput.on('change', @onValueSelectedHandler)

  onValueSelectedHandler: (e) ->
    e.preventDefault()
    if $(e.target).attr('id') == @baseColourInput.attr('id')
      @customColourInput.val('').trigger('chosen:updated')
    else
      @baseColourInput.val('').trigger('chosen:updated')
    @trigger('change')

  getValue: () ->
    if !_.isEmpty(@customColourInput.val())
      @customColourInput.val()
    else if !_.isEmpty(@baseColourInput.val())
      @baseColourInput.val()
    else
      ''

  setValue: (newValue) ->
    @baseColourInput.val(newValue).trigger('chosen:updated')
    # if base colours not have such value or we reseting all values
    if _.isEmpty(@baseColourInput.val())
      @customColourInput.val(newValue).trigger('chosen:updated')
    newValue

  isCustomColour: () ->
    _.isEmpty(@baseColourInput.val()) && !_.isEmpty(@customColourInput.val())

# this little different from other inputs, it's more like a widget
# we should have  customisationValues object in order to manage interdependencies
# between customisation values
window.inputs.CustomisationsSelector = class CustomisationsSelector extends BaseInput
  constructor: (@container) ->
    super()
    _.bindAll(@, 'onAddProductButtonClickHandler')
    @container.on('click', '.btn.empty.border', @onAddProductButtonClickHandler)

  onAddProductButtonClickHandler: (e) ->
    e.preventDefault()
    valueContainer = $(e.currentTarget).closest('.row.customisation-value')
    valueContainer.toggleClass('selected')
    CustomisationsSelector.syncLabelsWithSelectionState(valueContainer)
    @trigger('change')
    return

  getValue: () ->
    _.map(@container.find('.row.customisation-value.selected'), (item) ->
      $(item).data('customisation-value-id').toString()
    , @)

  # reset selected state for all items if not array passed
  setValue: (newValues) ->
    return if !_.isArray(newValues)
      _.each(@container.find('.row.customisation-value.selected'), (item) ->
        CustomisationsSelector.syncLabelsWithSelectionState($(item).removeClass('selected'))
      )
    else
      @container.find('.row.customisation-value.selected').removeClass('selected')
      _.each(newValues, (id) ->
        @container.find(".row.customisation-value[data-customisation-value-id=#{ id }").addClass('selected')
      , @)
      _.each(@container.find(".row.customisation-value"), CustomisationsSelector.syncLabelsWithSelectionState)

  # set markup accordingly to state [ selected, not selected, not available]
  @syncLabelsWithSelectionState: (valueContainer) ->
    button = valueContainer.find('.btn.empty.border')
    if valueContainer.is('.selected')
      button.html('ADDED')
    else
      button.html(' + ADD')
