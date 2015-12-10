window.inputs or= {}

# slighty different inputs, but with same interface
#
# opts:
#   container: #element with selections
#   action:    #toggle element

window.inputs.BaseProductOptionSelector = class BaseProductOptionSelector
  constructor: (@opts = {}) ->
    @$container = $(opts.container)
    @selector = new window.helpers.ProductSideSelectorPanel(@$container)
    @$action = $(opts.action).on('click', @open)


    @$eventBus = $({})
    @trigger  = delegateTo(@$eventBus, 'trigger')
    @on       = delegateTo(@$eventBus, 'on')
    @once     = delegateTo(@$eventBus, 'once')

    @setValue(opts.value) if opts.value

  open: () =>
    @selector.open()

  close: () =>
    setTimeout(@selector.close, 50)

  val: (newValue) ->
    if arguments.length == 0
      @getValue()
    else
      @setValue(newValue)
      return newValue

  getValue: () -> console.log('get value func is not defined')
  setValue: () -> console.log('set value func is not defined')

  prepareValue: (value) ->
    if _.isUndefined(value)
      return null
    else if @valueType == 'integer'
      parseInt(value)
    else
      value

  customValue: () ->
    return undefined

#  sizeInput = new inputs.ProductSizeIdSelector(
#   action: '#product-size-action',
#   container: '#product-size-content'
#  )
window.inputs.ProductSizeIdSelector = class ProductSizeIdSelector extends BaseProductOptionSelector
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('.product-option').on('click', @selectValueHandler)
    @$container.find('.btn-fit-guide').on('click', @showFitGuide)

  showFitGuide: =>
    @selector.close()
    (new window.modals.FitGuideModal()).show()

  getValue: () ->
    @$container.find('.active').data('id')

  customValue: () ->
    !!@$container.find('.active').data('price')

  setValue: (newValue) =>
    $el = @$container.find(".product-option[data-id=#{ newValue }]")
    return if !$el
    @setValueFrom($el)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    @$container.find('.product-option.active').not($el).removeClass('active')
    $el.addClass('active')

    data = $el.data()
    if data.price
      @$action.html("#{data.name} +#{data.price}")
    else
      @$action.html(data.name)

    @trigger('change')
    @close()


window.inputs.ProductColorIdSelector = class ProductColorIdSelector extends BaseProductOptionSelector
  constructor: (@opts = {}) ->
    super(opts)
    @$container.on('click', '.color-option:not(.disabled)', @selectValueHandler)

  getValue: () ->
    @$container.find('.active').data('id')

  customValue: () ->
    !!@$container.find('.active').data('price')

  setValue: (newValue) =>
    $el = @$container.find(".color-option:not(.disabled)[data-id=#{ newValue }]")
    return if !$el
    @setValueFrom($el)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    return if $el.length == 0
    data = $el.data()
    @$container.find('.color-option.active').not($el).removeClass('active')
    $el.addClass('active')

    if data.price
      @$action.html("#{data.name} +#{data.price}")
      _.delay( () ->
        window.helpers.showAlert(message: "We don’t have a picture of this style in the colour you've chosen. But trust us, it’s beautiful.")
      , 60)
    else
      @$action.html(data.name)

    @trigger('change')
    @close()

  enableCustomColors: () ->
    @$container.find('p.explanation').hide()
    @$container.find('.color-option.disabled').removeClass('disabled')

  disableCustomColors: (message) ->
    message ||= 'Express making is only available on our recommended colours'
    @$container.find('p.explanation').html(message).show()
    @$container.find('.color-option[data-custom=true]').addClass('disabled')

window.inputs.ProductCustomizationIdsSelector = class ProductCustomizationIdsSelector extends BaseProductOptionSelector
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('.customization-option').on('click', @selectValueHandler)

  getValue: () ->
    id = @$container.find('.active').data('id')
    if id == 'original'
      null
    else
      @prepareValue(id)

  # if we have any value.. this is custom
  customValue: () ->
    !!@getValue()

  setValue: (newValue) =>
    $el = @$container.find(".customization-option[data-id=#{ newValue }]")
    return if !$el
    @setValueFrom($el)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    data = $el.data()

    @$container.find('.customization-option.active').not($el).removeClass('active')
    $el.addClass('active')

    if data.id == 'original'
      @$action.html("Customize")
    else
      @$action.html("#{data.name} +#{data.price}")

    @trigger('change')
    @close()

window.inputs.ProductMakingOptionIdSelector = class ProductMakingOptionIdSelector extends BaseProductOptionSelector
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('.making-option').on('click', @selectValueHandler)

  open: () ->
    if @$action.hasClass('disabled')
      console.log("making options don't available for custom colors")
    else
      @selector.open()

  getValue: () ->
    id = @$container.find('.active').data('id')
    if id == 'original' || @disabled
      null
    else
      @prepareValue(id)

  # no value can create dress custom
  customValue: () ->
    false

  setValue: (newValue) =>
    $el = @$container.find(".making-option[data-id=#{ newValue }]")
    return if !$el
    @setValueFrom($el)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    data = $el.data()

    @$container.find('.making-option.active').not($el).removeClass('active')
    $el.addClass('active')

    @setTitlesForCurrentValue(data)

    @trigger('change')
    @close()

  disable: () ->
    @disabled = true
    @$action.addClass('disabled')
    @close()
    @setTitlesForCurrentValue()

  enable: () ->
    @disabled = false
    @$action.removeClass('disabled')
    @setTitlesForCurrentValue()

  setTitlesForCurrentValue: (data) ->
    data ||= @$container.find('.active').data()

    if @disabled
      @$action.html("Standard making 3-9 days")
    else if data? and data.id == 'original'
      @$action.html("Standard Making 3-9 days")
    else if data? and data.name
      price = if data.price == "$0.00" then "FREE!" else data.price
      @$action.html("#{data.name} +#{price}")
    else
      @$action.html("Express Making")

# TODO - Another expedient use of existing classes instead of rewriting the whole shebang in react.
window.inputs.ProductHeightSelector = class ProductHeightSelector extends BaseProductOptionSelector
  constructor: (opts = {}) ->
    super(opts)

    @value = 'standard'

    @$container.find('.height-option').on('click', @selectValueHandler)
    @$container.find('.close').on('click', @close)
    @on('change', @updateMenuButton)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    data = $el.data()
    @setValue(data.heightOption)

    @$container.find('.height-option.active').not($el).removeClass('active')
    $el.addClass('active')

  updateMenuButton: () =>
    selectedValue = @getValue()
    if selectedValue
      newTitle = "Height - " + selectedValue
      @$action.html(newTitle)

  getValue: () ->
    @value
  setValue: (newValue) ->
    if @value != newValue
      @trigger('change')
      @value = newValue

  customValue: =>
    @getValue() != 'standard'
