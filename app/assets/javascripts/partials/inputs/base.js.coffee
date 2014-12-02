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
  easing_time = 380

  constructor: (@container, @buttons_selector) ->
    super()
    _.bindAll(@, 'onButtonClickHandler')
    @container.on('click', @buttons_selector, @onButtonClickHandler)
    @makeDropdown(@container)
    @container.find("#{@buttons_selector}[title]").tooltipsy()

  # private
  onButtonClickHandler: (e) ->
    e.preventDefault()
    return if $(e.target).is('.unavailable')
    $(e.target).closest('.sizebox').find('.button').removeClass('selected')
    $(e.target).addClass('selected')
    @container.find('.dropdown-content').fadeOut(easing_time)
    @trigger('change')
    @closeDropdown(@container.find('.dropdown-button'), @container.find('.dropdown-content'))

  getValue: () ->
    value = @container.find("#{@buttons_selector}.selected:first").data('size')
    if !_.isUndefined(value)
      return value
    else
      return null

  setValue: (newValue) ->
    selectedButton = @container.find("#{@buttons_selector}[data-size='#{ newValue }']")
    selectedButton.closest('.sizebox').find('.button').removeClass('selected')
    selectedButton.addClass('selected')
    return newValue

  makeDropdown: (@container) ->
    @container.find('.dropdown-size').wrapAll('<div class="dropdown-content"></div>')
    @bindDropdown(@container.find('.dropdown-button'), @container.find('.dropdown-content'))

  bindDropdown: (button, dropdown) ->
    button.on 'click', @toggleDropdown
    dropdown.on 'mouseleave', => @closeDropdown(button, dropdown)

  toggleDropdown: () ->
    $this = $(this)
    $this.text if $.trim($this.text()) is $this.data('close') then $this.data('open') else $this.data('close')
    $this.toggleClass('selected').next('.dropdown-content').toggle()

  closeDropdown: (button, dropdown) ->
    if button.is('.selected')
      dropdown.fadeOut(easing_time)
      button.removeClass('selected').text('+')

  disableSelectionOptions: (unavailable_values, text) ->
    site_version = window.current_site_version.permalink
    if site_version == 'au'
      base_size = 18
    else
      base_size = 14
    _.each(@container.find(@buttons_selector), (button) ->
      $button = $(button)
      value = $button.data('size')
      plus_size = $button.data('plussize')
      if $button.data('tooltipsy')
        $button.data('tooltipsy').destroy()
      $button.removeData('tooltip')
      if _.indexOf(unavailable_values, value) == -1
        console.log(plus_size)
        if value >= base_size && plus_size != true
          $button.removeClass('unavailable').attr('title', "This size is an additional $20")
        else
          $button.removeClass('unavailable').removeAttr('title')
      else
        $button.addClass('unavailable').attr('title', text)

    , @)
    @container.find("#{@buttons_selector}[title]").tooltipsy()

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

  disableSelectionOptions: (unavailable_values, text) ->
    _.each(@container.find("option[value!='']"), (option) ->
      $option = $(option)
      value = @prepareValue($option.attr('value'))

      if _.indexOf(unavailable_values, value) == -1
        $option.removeAttr('disabled').removeClass('unavailable')
        $option.html(value)
      else
        $option.addClass('unavailable').attr('disabled', 'disabled')
        $option.html("<span style='text-decoration: line-through;'>#{value} SOLD OUT</span>")

    , @)
    @container.trigger('chosen:updated')

window.inputs.GroupedOptionsChosenSelector = class GroupedOptionsChosenSelector extends BaseInput
  constructor: (@container, @valueType = 'string') ->
    super()
    _.bindAll(@, 'onValueChanged')
    @container.on('change', @onValueChanged)

  isCustomOption: () ->
    # selected option has class 'custom'
    @container.find("option[value=#{ @container.val() }]").is('.custom')

  getOptionValueId: () ->
    value = @container.find("option[value=#{ @container.val() }]").data('id')
    @prepareValue(value)

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
    @container.on('click', '.customisation-value a.btn', @onAddProductButtonClickHandler)
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
    $button = $valueContainer.find('.btn')
    if new_state == 'selected'
      $valueContainer.addClass('selected').removeClass('unavailable')
      $button.html('ADDED')
    else if new_state == 'available'
      $valueContainer.removeClass('selected').removeClass('unavailable')
      $button.html('+ ADD')
    else if new_state == 'incompatible'
      $valueContainer.removeClass('selected').addClass('unavailable')
      $button.html('NOT COMPATIBLE')
