# user products slider in header
# 'view' element
#= require templates/shopping_bag
window.ShoppingBag = class ShoppingBag
  transition_end_events = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'

  constructor: (options = {}) ->
    @template   = JST['templates/shopping_bag']
    @cart       = options.cart # window.shopping_cart
    @rendered   = false
    @auto_open  = options.auto_open
    @country_code = options.country_code

    @$overlay   = $(options.overlay || '#shadow-layer')
    @$container = $(options.container || '#cart')
    @$mobileMenu= $('#mobile-menu')

    _.bindAll(@, 'closeHandler', 'openHandler', 'open', 'close', 'render', 'removeProductHandler', 'couponFormSubmitHandler', 'removeProductCustomizationHandler', 'removeProductMakingOptionHandler')

    $(options.toggle_link || '#cart-trigger').on('click', @openHandler)

    @$container.on('click', '.close-cart', @closeHandler)
    @$overlay.on('click', @closeHandler)
    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('click', '.customization-remove', @removeProductCustomizationHandler)
    @$container.on('click', '.making-option-remove', @removeProductMakingOptionHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)

    @cart.on('change', @render)

    if @auto_open
      @open()
    @

  render: () ->
    @$container.html(@template(cart: @cart.data, country_code: @country_code))
    @rendered = true

  close: () ->
    @$overlay.removeClass('is-visible')
    @$container.removeClass('speed-in').one(transition_end_events, () ->
      $('body').removeClass('overflow-hidden')
    )
    @$mobileMenu.show()

  open: () ->
    @render() if !@rendered
    @$container.addClass('speed-in').one(transition_end_events, () ->
      $('body').addClass('overflow-hidden')
    )
    @$overlay.addClass('is-visible')
    @$mobileMenu.attr("style","display:none !important")

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
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    @cart.removeProduct(line_item_id)

  removeProductCustomizationHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    customization_id = $(e.currentTarget).data('id')
    @cart.removeProductCustomization(line_item_id, customization_id)

  removeProductMakingOptionHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).closest('.cart-item').data('id')
    making_option_id = $(e.currentTarget).data('id')
    @cart.removeProductMakingOption(line_item_id, making_option_id)

  couponFormSubmitHandler: (e) ->
    e.preventDefault() if e
    $input = @$container.find('#promotion-code')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())
