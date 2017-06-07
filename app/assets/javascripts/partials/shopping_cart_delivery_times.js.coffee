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
      'handleRemoveDeliveryTime',
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
    $('.js-remove-making-option').on('click', @handleRemoveDeliveryTime)
    $('.js-create-making-option').on('click', @handleAddDeliveryTime)

  handleAddDeliveryTime: (evt) ->
    FIELDSET_CLASS = '.js-delivery-times-fieldset'
    $input = $(evt.target)
    $fieldset = $input.closest(FIELDSET_CLASS)
    lineItemId = $fieldset.data().lineItemId
    @processingIndex = $fieldset.data().lineItemIndex
    window.app.shopping_cart.createMakingOption(lineItemId, $input.val())

  handleRemoveDeliveryTime: (evt) ->
    FIELDSET_CLASS = '.js-delivery-times-fieldset'
    $fieldset = $(evt.target).closest(FIELDSET_CLASS)
    @processingIndex = parseInt($fieldset.data().lineItemIndex, 10)
    lineItem = @cart.data.products[@processingIndex]
    makingOption = if lineItem.making_options && lineItem.making_options.length > 0 then lineItem.making_options[0].id else undefined

    if makingOption
      window.app.shopping_cart.deleteMakingOption(lineItem.line_item_id, makingOption)

  handleRequestProcessing: () ->
    $('.js-delivery-times-wrapper[data-index=' + @processingIndex + ']').addClass('is-loading')

  handleRequestEnd: () ->
    $('.js-delivery-times-wrapper[data-index=' + @processingIndex + ']').removeClass('is-loading')


  determineChecked: () ->
    @cart.data.products.forEach(@initCheckbox)

  initCheckbox: (p, i) ->
    isDefaultChosen = p.making_options.length == 0

    if isDefaultChosen
      $selection = $("#delivery_time_normal_" + i)
    else
      # find element by name and index
      $selection = $("#delivery_time_" + p.making_options[0].name.toLowerCase().replace(" ", "") + '_' + i)

    $selection.attr('checked', true)
    $selection.closest('.js-delivery-time-options-wrapper').addClass('is-selected')

  render: () ->
    @$container.html(@template(cart: @cart.data))

  handleCartChange: () ->
    @render()
    @determineChecked()
    @bindEventHandlers()
