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
  constructor: (@container, @valueType = 'string') ->
    super()
    _.bindAll(@, 'onValueChanged')
    @container.on('change', @onValueChanged)

  onValueChanged: (e) ->
    @trigger('change')

  getValue: () ->
    @prepareValue(@container.val())

  setValue: (newValue) ->
    @container.val(newValue).trigger('chosen:updated')

  prepareValue: (value) ->
    if _.isUndefined(value)
      return null
    else if @valueType == 'integer'
      parseInt(value)
    else
      value


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
  allValuesIds: []

  constructor: (@container, @incompatibility_map) ->
    super()
    _.bindAll(@, 'onAddProductButtonClickHandler')
    @container.on('click', '.customisation-value .btn.empty.border', @onAddProductButtonClickHandler)
    @allValuesIds = _.map(@container.find('.customisation-value'), (item) -> $(item).data('customisation-value-id'))

  onAddProductButtonClickHandler: (e) ->
    e.preventDefault()
    valueContainer = $(e.currentTarget).closest('.customisation-value')
    return if valueContainer.is('.unavailable')

    valueContainer.toggleClass('selected')
    value_id = valueContainer.data('customisation-value-id')
    if valueContainer.is('.selected')
      @updateValuesContainer(value_id, 'selected')
    else
      @updateValuesContainer(value_id, 'available')
    @updateIncompatibility()
    @trigger('change')
    return

  getValue: () ->
    _.map(@container.find('.customisation-value.selected'), (item) ->
      parseInt($(item).data('customisation-value-id'))
    , @)

  # reset selected state for all items if not array passed
  setValue: (newValues) ->
    # reset old values
    @updateValuesContainer(@allValuesIds, 'available')
    @updateValuesContainer(newValues, 'selected') if _.isArray(newValues)

  updateIncompatibility: () ->
    selected_items = @getValue()
    # note: possible, we should contain values in js, and DOM only reflects state
    incompatible_items = _.map(selected_items, (item_id) ->
      @incompatibility_map[item_id] || []
    , @)
    incompatible_items = _.union.apply(@, incompatible_items)
    available_items = _.difference(@allValuesIds, selected_items, incompatible_items)
    @updateValuesContainer(incompatible_items, 'incompatible')
    @updateValuesContainer(available_items, 'available')

  updateValuesContainer: (value_ids, new_state) ->
    value_ids = [value_ids] if !_.isArray(value_ids)
    _.each(value_ids, (value_id) ->
      @updateValueContainer(value_id, new_state)
    , @)

  updateValueContainer: (value_id, new_state) ->
    $valueContainer = @container.find(".customisation-value[data-customisation-value-id=#{ value_id }]")
    $button = $valueContainer.find('.btn.empty.border')
    if new_state == 'selected'
      $valueContainer.addClass('selected').removeClass('unavailable')
      $button.html('ADDED')
    else if new_state == 'available'
      $valueContainer.removeClass('selected').removeClass('unavailable')
      $button.html('+ ADD')
    else if new_state == 'incompatible'
      $valueContainer.removeClass('selected').addClass('unavailable')
      $button.html('NOT COMPATIBLE')
