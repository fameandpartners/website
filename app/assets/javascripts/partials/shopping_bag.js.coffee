# user products slider in header
# 'view' element
#= require templates/shopping_bag
window.ShoppingBag = class ShoppingBag
  transition_end_events = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'

  constructor: (options = {}) ->
    @template   = JST['templates/shopping_bag']
    @cart       = options.cart # window.shopping_cart
    @rendered   = false

    @$overlay   = $(options.overlay || '#shadow-layer')
    @$container = $(options.container || '#cart')

    _.bindAll(@, 'closeHandler', 'openHandler', 'open', 'close', 'render', 'removeProductHandler', 'couponFormSubmitHandler')

    $(options.toggle_link || '#cart-trigger').on('click', @openHandler)

    @$container.on('click', '.close-cart', @closeHandler)
    @$overlay.on('click', @closeHandler)
    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)

    @cart.on('change', @render)
    @

  render: () ->
    @$container.html(@template(cart: @cart.data))
    @rendered = true

  close: () ->
    @$overlay.removeClass('is-visible')
    @$container.removeClass('speed-in').one(transition_end_events, () ->
      $('body').removeClass('overflow-hidden')
    )

  open: () ->
    @render() if !@rendered
    @$container.addClass('speed-in').one(transition_end_events, () ->
      $('body').addClass('overflow-hidden')
    )
    @$overlay.addClass('is-visible')

  openHandler: (e) ->
    e.preventDefault() if e
    if @cart.isLoaded()
      @open()
    else
      @cart.one('load', @open)
      @cart.load()

  closeHandler: (e) ->
    e.preventDefault() if e
    @close()

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).data('id')
    @cart.removeProduct(line_item_id)

  couponFormSubmitHandler: (e) ->
    e.preventDefault() if e
    $input = @$container.find('#promotion-code')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())

#$ ->
#  return unless window.bootstrap?
#
#  window.shopping_cart.init(window.bootstrap)
#
#  window.shoppingBag = {
#    container: null
#    cartTemplate: JST['templates/shopping_cart']
#    carouselEnabled: false
#    listeners: []
#
#    init: () ->
#      window.shoppingBag.container = $('#wrap .cart')
#
##      shoppingBag.updateElementsHandlers()
#      shoppingBag.container.find("#shopping-bag-popup-wrapper").hide()
#      shoppingBag.container.find(".shopping-bag-toggler").on(
#        'click', shoppingBag.toggleVisibilityClickHandler
#      )
#
#      shoppingBag.container.on 'mouseleave', '#shopping-bag-popup-wrapper', (event) ->
#        if shoppingBag.closeTimerId
#          clearTimeout(shoppingBag.closeTimerId)
#
#        shoppingBag.closeTimerId = setTimeout shoppingBag.hide, 5000
#
#      shoppingBag.container.on 'mouseenter', '#shopping-bag-popup-wrapper', (event) ->
#        $wrapper = shoppingBag.container.find("#shopping-bag-popup-wrapper")
#
#        if shoppingBag.closeTimerId
#          clearTimeout(shoppingBag.closeTimerId)
#          shoppingBag.closeTimerId = null
#
#      window.shopping_cart.on('item_added',   shoppingBag.renderCart)
#      window.shopping_cart.on('item_changed', shoppingBag.renderCart)
#      window.shopping_cart.on('item_removed', shoppingBag.renderCart)
#
##    removeProductClickHandler: (e) ->
##      e.preventDefault()
##      variantId = $(e.currentTarget).data('id')
##      window.shopping_cart.removeProduct(variantId)
#
#    closeButtonClickHandler: (e) ->
#      e.preventDefault()
#      shoppingBag.hide()
#
#    toggleVisibilityClickHandler: (e) ->
#      e.preventDefault()
#      if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
#        shoppingBag.hide()
#      else
#        shoppingBag.show()
#
#    offBagClickHandler: (e) ->
#      if shoppingBag.container.has($(e.target)).length == 0
#        window.shoppingBag.hide()
#
#    show: () ->
#      if !shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
#        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow", () ->
#          shoppingBag.updateCarousel() if !shoppingBag.carouselEnabled
#        )
#        $(document).on('click', shoppingBag.offBagClickHandler)
#      window.shoppingBag
#
#    hide: () ->
#      $(document).off('click', shoppingBag.offBagClickHandler)
#      if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
#        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow", () ->
#          clearTimeout(shoppingBag.closeTimerId) if shoppingBag.closeTimerId?
#        )
#      window.shoppingBag
#
#    # show and hide popup
#    showTemporarily: (period = 5000) ->
#      return if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
#      shoppingBag.show()
#      clearTimeout(shoppingBag.closeTimerId) if shoppingBag.closeTimerId?
#      shoppingBag.closeTimerId = setTimeout(shoppingBag.hide, period)
#
#    renderCart: (e, data) ->
#      window.cart_info = data
#      cartHtml = shoppingBag.cartTemplate
#        opened: shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
#        order: data.cart
#        csrf_param: $('[name="csrf-param"]').attr('content')
#        csrf_token: $('[name="csrf-token"]').attr('content')
#      shoppingBag.container.find('#shopping-bag-popup-wrapper').replaceWith(cartHtml)
#
#      #shoppingBag.show()
#      # update actions
#      #shoppingBag.updateElementsHandlers()
#      shoppingBag.carouselEnabled = false
#      shoppingBag.updateCarousel(data.id)
#      item_count = _.reduce(data.cart.line_items, ((memo, item) -> memo += item.quantity), 0)
#      $('a.shopping-bag-toggler .counter').html(item_count)
#
#      _.each(shoppingBag.listeners, (listener) -> listener.call())
#      shoppingBag.listeners = []
#
#    afterUpdateCallback: (callback) ->
#      unless _.contains(shoppingBag.listeners, callback)
#        shoppingBag.listeners.push(callback)
#
##    updateElementsHandlers: () ->
##      shoppingBag.container.find('.remove-item-from-cart')
##        .off('click', shoppingBag.removeProductClickHandler)
##        .on('click', shoppingBag.removeProductClickHandler)
#
#    updateCarousel: (variantId) ->
#      # currently, shopping bag doesn't have carousel
#      return
#      return unless $("#shopping-bag-popup").is(":visible")
#
#      start = $('#shopping-bag-popup').first().find(' > li')
#        .index($("li:has(a.remove-item-from-cart[data-id='#{variantId}'])"))
#      start = 0 if start < 0 # -1 : not found
#
#      items_count = 2
#      items_count = 1 if window.shopping_cart.line_items.length == 1
#      options = window.helpers.get_vertical_carousel_options({
#        items: items_count, start: start,
#        prev: { button: "#shopping-arrow-up", items: 2 },
#        next: { button: "#shopping-arrow-down", items: 2 }
#      })
#      $("#shopping-bag-popup").carouFredSel(options)
#      $("#shopping-bag-popup").trigger('slideTo', start)
#      shoppingBag.carouselEnabled = true
#  }
#
#  shoppingBag.init()
