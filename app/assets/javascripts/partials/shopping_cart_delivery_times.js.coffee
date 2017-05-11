#= require templates/shopping_cart_delivery_times
window.ShoppingCartDeliveryTimes = class ShoppingCartDeliveryTimes
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_delivery_times']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '.js-shopping_cart_delivery_times')
    console.log('options', options)
    console.log('@template', @template)
    _.bindAll(@, 'render', 'determineChecked', 'bindEventHandlers', 'handleRemoveDeliveryTime', 'handleAddDeliveryTime')
    @cart.on('change', @render)

    @render()
    @determineChecked()
    @bindEventHandlers()
    @

  bindEventHandlers: () ->
    $('.js-remove-making-option').on('click', @handleRemoveDelivery)
    $('.js-create-making-option').on('click', @handleAddDeliveryTime)

  handleAddDeliveryTime: (evt) ->
    FIELDSET_CLASS = '.js-delivery-times-fieldset'
    $input = $(evt.target)
    $fieldset = $input.closest(FIELDSET_CLASS)
    lineItemId = $fieldset.data().lineItemId
    chosenVal = $input.val()
    console.log 'adding'
    window.app.shopping_cart.createMakingOption(lineItemId, chosenVal)

  handleRemoveDeliveryTime: (evt) ->
    FIELDSET_CLASS = '.js-delivery-times-fieldset'
    $fieldset = $(evt.target).closest(FIELDSET_CLASS)
    index = parseInt($fieldset.data().lineItemIndex, 10)
    lineItem = @cart.data.products[index]
    makingOption = if lineItem.making_options && lineItem.making_options.length > 0 then lineItem.making_options[0].id else undefined
    console.log 'removing'

    if makingOption
      window.app.shopping_cart.deleteMakingOption(lineItemId, makingOption)

  determineChecked: () ->
    @cart.data.products.forEach(@initCheckbox)

  initCheckbox: (p, i) ->
    isDefaultChosen = p.making_options.length == 0
    makingOptionChosen = p.making_options[i]

    if isDefaultChosen
      $selection = $("#delivery_time_normal_" + i)
    else
      $selection = $("#delivery_time_" + p.making_option.id + '_' + i)

    $selection.attr('checked', true)

  render: () ->
    @$container.html(@template(cart: @cart.data))
