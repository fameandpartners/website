# actually, shopping cart is  model, not view
# new ShoppingCart({ bootstrap or nil })
#
window.helpers or= {}
window.helpers.ShoppingCart = class ShoppingCart
  constructor: (options = {}) ->
    @$eventBus = $({})
    # code
    @data    = { item_count: 0, products: [] }
    @loaded   = false

    @trigger =  delegateTo(@$eventBus, 'trigger')
    @on      =  delegateTo(@$eventBus, 'on')
    @one     =  delegateTo(@$eventBus, 'one')
    @track    = options.track || false

  setItemCount: (item_count) =>
    return if @loaded
    @data.item_count = item_count
    @trigger('change')

  updateData: (data) =>
    @loaded = true
    @data = data
    @trigger('change')
    @trigger('requestEnd')

  # request to force data requesting from server
  # if already loaded, do nothing. it should be done by other methods
  load: (force = false, callback=null) ->
    if @isLoaded() && !force
      @trigger('load')
    else
      @loaded = true
      $.ajax(
        url: "/user_cart/details"
        type: "GET"
        dataType: "json"
      ).success((data) =>
        @updateData(data)
        @trigger('load')
        callback() if (callback)
      ).error( () =>
        @loaded = false
      )

  isLoaded: () ->
    !!@loaded

  data: () ->
    @data

  # options:
  #   variant_id
  #   size_id
  #   color_id
  #   customizations_ids
  addProduct: (product_data = {}) ->
    $.ajax(
      url: "/user_cart/products"
      type: "POST"
      dataType: "json"
      data: product_data
    ).success((data) =>
      added_product = _.find((data.line_items || []), (product) ->
        product.variant_id == product_data.variant_id
      )
      @trackAddToCart(added_product)
      window.location = '/checkout'
    ).error( () =>
      @trigger('error')
    )

  findProduct: (line_item_id) ->
    found_product;
    for product in @data.line_items
      if (product.id == line_item_id)
        found_product = product

    return found_product


  removeProduct: (line_item_id) ->
    found_product = @findProduct(line_item_id)

    return if !found_product || !window.dataLayer

    window.dataLayer.push({
      event: 'removeFromCart',
      ecommerce: {
        remove: {
          products: [{
            id: found_product.id,
            name: found_product.name,
            price: found_product.price.amount,
            category: 'Dress',
            variant: found_product.variant_id,
            quantity: 1,
          }],
        },
      },
    }); 
    $.ajax(
      url: "/user_cart/products/#{line_item_id}"
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )


  createMakingOption: (line_item_id, making_option_id) ->
    @trigger('requestProcessing')
    $.ajax(
      url: "/user_cart/products/#{line_item_id}/making_options/#{making_option_id}"
      type: "POST"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  updateProduct: (line_item_id, data) ->
    $.ajax(
      url: "/user_cart/products/#{line_item_id}"
      type: "PUT"
      dataType: "json",
      data: data
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  # apply code
  # note - error messages placed here, if something changed - move this upper in logic
  applyPromotionCode: (code) ->
    $.ajax(
      url: "/user_cart/promotion",
      type: 'POST',
      dataType: "json",
      data: { promotion_code: code }
    ).success((data) =>
      if data.error
        @trigger('error', data)
        @trigger('complete', data)
        window.helpers.showAlert(message: data.error)
      else
        @updateData(data)
        @trigger('success', data)
        @trigger('complete', data)
        window.helpers.showAlert( type: 'success', title: 'Success!', message: 'You are one step closer to being a fame babe')
    ).error( () =>
      @trigger('error')
    )

  applyReturnTypePromoCode: (code) ->
    $('.js-returns-trigger').toggleClass('AJAX__in-process')

    $.ajax(
      url: "/user_cart/promotion",
      type: 'POST',
      dataType: "json",
      data: { promotion_code: code }
    ).success((data) =>
      if data.error
        $('.js-returns-trigger')
          .toggleClass('AJAX__in-process')
          .prop('checked', false)
        console.log(data.error)
        @trigger('error', data)
        @trigger('complete', data)
      else
        @updateData(data)
        @toggleReturnsDepositMessage()
        @trigger('success', data)
        @trigger('complete', data)
    ).error( () =>
      $('.js-returns-trigger')
        .toggleClass('AJAX__in-process')
        .prop('checked', false)
      @trigger('error')
    )

  toggleReturnsDepositMessage: () ->
    returnInsurance = @data.line_items.filter (i) -> i.name == 'RETURN_INSURANCE'

    if (returnInsurance.length)
      $('.js-returns-abc-option-message').removeClass('hidden');
    else
      $('.js-returns-abc-option-message').addClass('hidden');