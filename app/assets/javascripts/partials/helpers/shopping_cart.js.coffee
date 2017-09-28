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

  showModal: () ->
    if @shouldShowAddToCartModal()
      @showAddToCartModal()

  showAddToCartModal: () ->
    if $.cookie('add-to-cart-modal-displayed') != 'true'
      addToCartModal = new window.page.EmailCaptureModal({
        promocode: "HALFOFF",
        content: "",
        container: "#modal-add-to-cart-template",
        heading: "Love two dresses?",
        message: "<h3><strong>Buy both and we will give you 50% off the second dress</strong/><br/>Hurry, offer ends soon.</h3><div><a class=\"btn btn-black\" onclick=\"vex.closeAll();\">Add another dress</a/></div/>",
        className: "new-modal welcome-modal",
        timeout: 0,
        timer: false,
        force: false
      });
      $.cookie('add-to-cart-modal-displayed','true')

  shouldShowAddToCartModal: () ->
    $("#modal-add-to-cart-template").length != 0

  # options:
  #   variant_id
  #   size_id
  #   color_id
  #   customizations_ids
  addProduct: (product_data = {}) ->
    # @showModal()

    $.ajax(
      url: "/user_cart/products"
      type: "POST"
      dataType: "json"
      data: product_data
    ).success((data) =>
      added_product = _.find((data.products || []), (product) ->
        product.variant_id == product_data.variant_id
      )
      @trackAddToCart(added_product)
      window.location = '/checkout'
    ).error( () =>
      @trigger('error')
    )

  removeProduct: (line_item_id) ->
    $.ajax(
      url: "/user_cart/products/#{line_item_id}"
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  deleteMakingOption: (line_item_id, making_option_id) ->
    @trigger('requestProcessing')
    $.ajax(
      url: "/user_cart/products/#{line_item_id}/making_options/#{making_option_id}"
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

  removeProductCustomization: (line_item_id, customization_id) ->
    $.ajax(
      url: "/user_cart/products/#{line_item_id}/customizations/#{customization_id}"
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  removeProductMakingOption: (line_item_id, making_option_id) ->
    $.ajax(
      url: "/user_cart/products/#{line_item_id}/making_options/#{making_option_id}"
      type: "DELETE"
      dataType: "json"
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
    if (code == 'deliverydisc')
      option = 'A'
    else if (code == 'deliveryins')
      option = 'B'

    $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')

    $.ajax(
      url: "/user_cart/promotion",
      type: 'POST',
      dataType: "json",
      data: { promotion_code: code }
    ).success((data) =>
      if data.error
        $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')
        $('.js-returns-trigger-' + option).prop('checked', false)
        console.log(data.error)
        @trigger('error', data)
        @trigger('complete', data)
      else
        @updateData(data)
        @trigger('success', data)
        @trigger('complete', data)
    ).error( () =>
      $('.js-returns-trigger-' + option).toggleClass('AJAX__in-process')
      $('.js-returns-trigger-' + option).prop('checked', false)
      @trigger('error')
    )


  # analytics
  trackAddToCart: (product) ->
    try
      if @track
        window.track.addedToCart(product.analytics_label, product)

        if _cio
          _cio.track("addedToCart", {
            sku: product.sku,
            name: product.name,
            color: product.color.name,
            size: product.size?.presentation,
            value: product.price.amount,
            currency: product.price.currency
          });
    catch
      # do nothing
