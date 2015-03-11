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
    @$action = $(opts.action).on('click', @selector.open)


    @$eventBus = $({})
    @trigger  = delegateTo(@$eventBus, 'trigger')
    @on       = delegateTo(@$eventBus, 'on')
    @once     = delegateTo(@$eventBus, 'once')

    @setValue(opts.value) if opts.value

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

#  sizeInput = new inputs.ProductSizeIdSelector(
#   action: '#product-size-action',
#   container: '#product-size-content'
#  )
window.inputs.ProductSizeIdSelector = class ProductSizeIdSelector extends BaseProductOptionSelector
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('.product-option').on('click', @selectValueHandler)

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
    @$container.find('.color-option').on('click', @selectValueHandler)

  getValue: () ->
    @$container.find('.active').data('id')

  customValue: () ->
    !!@$container.find('.active').data('price')

  setValue: (newValue) =>
    $el = @$container.find(".color-option[data-id=#{ newValue }]")
    return if !$el
    @setValueFrom($el)

  selectValueHandler: (e) =>
    e.preventDefault() if e
    @setValueFrom($(e.currentTarget))

  setValueFrom: ($el) ->
    data = $el.data()

    @$container.find('.color-option.active').not($el).removeClass('active')
    $el.addClass('active')

    if data.price
      @$action.html("#{data.name} +#{data.price}")
      _.delay( () ->
        window.helpers.showAlert(message: "You have selected a custom color, so we don't have a pic of this dress yet")
      , 60)
    else
      @$action.html(data.name)

    @trigger('change')
    @close()

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
