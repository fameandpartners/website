#= require templates/shopping_cart_delivery_times
window.ShoppingCartDeliveryTimes = class ShoppingCartDeliveryTimes
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_delivery_times']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '.js-shopping_cart_delivery_times')
    @processingIndex = undefined
    _.bindAll(@,
      'render',
      'determineChecked',
      'bindEventHandlers',
      'handleAddDeliveryTime',
      'handleCartChange',
      'handleRequestProcessing'
      'handleRequestEnd'
    )
    @cart.on('change', @handleCartChange)
    @cart.on('requestProcessing', @handleRequestProcessing)
    @cart.on('requestEnd', @handleRequestEnd)

    @render()
    @determineChecked()
    @bindEventHandlers()
    @

  bindEventHandlers: () ->
    $('.js-create-making-option').on('click', @handleAddDeliveryTime)

  handleAddDeliveryTime: (evt) ->
    FIELDSET_CLASS = '.js-delivery-times-fieldset'
    $input = $(evt.target)
    $fieldset = $input.closest(FIELDSET_CLASS)
    lineItemId = $fieldset.data().lineItemId
    @processingIndex = $fieldset.data().lineItemIndex
    window.app.shopping_cart.createMakingOption(lineItemId, $input.val())

  handleRequestProcessing: () ->
    $('.js-delivery-times-wrapper[data-index=' + @processingIndex + ']').addClass('is-loading')

  handleRequestEnd: () ->
    $('.js-delivery-times-wrapper[data-index=' + @processingIndex + ']').removeClass('is-loading')


  determineChecked: () ->
    @cart.data.line_items.forEach(@initCheckbox)

  initCheckbox: (p, i) ->
    if p.making_options.length == 0
      return
    
    $selection = $("#delivery_time_" + i + '_' + p.making_options[0].id)
    $selection.attr('checked', true)
    $selection.closest('.js-delivery-time-options-wrapper').addClass('is-selected')

  render: () ->
    @$container.html(@template(cart: @cart.data))

  handleCartChange: () ->
    @render()
    @determineChecked()
    @bindEventHandlers()
