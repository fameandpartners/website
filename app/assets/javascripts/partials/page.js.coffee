window.page = {
  enableShoppingCart: () ->
    window.shopping_cart.init(window.bootstrap)

  enableProductVariantsSelector: (parentContainer) ->
    if window.product_variants
      window.page.variantsSelector = window.helpers.createProductVariantsSelector(parentContainer)
      window.page.variantsSelector.init(window.product_variants)

  enableQuickView: (container, selector = '*[data-action="quick-view"]') ->
    container.on('click', selector, (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      popup = new popups.ProductQuickView(productId)
      popup.show()
      return
    )

  enableWhatSizeIam: (link) ->
    link.fancybox({width: '1000', height: '183'})

  enableBuyButton: (button, options = {}) ->
    window.helpers.addBuyButtonHandlers(button, options)

  enableSendToFriendButton: (buttons) ->
    buttons.on('click', (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data('product')
      popups.showSendToFriendPopup(productId, { analyticsLabel: window.product_analytics_label })
    )

  enableAccordeonBars: (elements) ->
    hide = (elements) ->
      elements.find('.text').slideUp(500, () ->
        $(this).hide().closest('li').removeClass('opened')
      )

    show = (elements) ->
      elements.find('.text').slideDown(500, () ->
        $(this).show().closest('li').addClass('opened')
      )

    elements.on('click', (e) ->
      e.preventDefault()
      target = $(e.target).closest('li')

      if target.is('.opened')
        hide(target.siblings('.opened').andSelf())
      else
        show(target)
        hide(target.siblings('.opened'))
    )

  enableWishlistLinks: (links) ->
    productWishlist.addWishlistButtonActions(links)

  enableImageZoomButtons: (buttons) ->
    # possible, we should move this code to image_viewer
    buttons.on('click', (e) ->
      source = $(e.target).closest('*[data-image]')
      bigImageUrl = source.data('image')
      if bigImageUrl?
        bigImageUrl = (location.origin + bigImageUrl) if !bigImageUrl.match(/^https?:\/\//)
        $.fancybox href: bigImageUrl

      return false
    )

  enableSoundCloudSongPlayer: (links) ->
    links.on('click', (e) ->
      player = $(e.currentTarget).closest('.picture').find('.sc-player')
      player.find('.sc-controls a.sc-pause').click()

      return false
    )

  enablePersonalisatonForm: (container) ->
    if window.product_variants
      form = window.helpers.createPersonalisationForm(container)
      form.init(window.product_variants, window.product_master_variant)
      form
}
