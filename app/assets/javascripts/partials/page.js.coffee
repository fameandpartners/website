window.page = {
  enableShoppingCart: () ->
    window.shopping_cart.init(window.bootstrap)

  enableProductVariantsSelector: (parentContainer) ->
    if window.product_variants
      window.page.variantsSelector = window.helpers.createProductVariantsSelector(parentContainer)
      window.page.variantsSelector.init(window.product_variants)

  enableWhatSizeIam: (link) ->
    link.fancybox({
      width: '870', 
      padding: 40,
      height: 'auto', 
      'scrolling': 'no', 
      fitToView: false,
      helpers: {
        overlay: {
          locked: false
        }
      }
    })

  enableBuyButton: (button, options = {}) ->
    window.helpers.addBuyButtonHandlers(button, options)

  enableSendToBrideButton: (element) ->
    window.helpers.addSendToBrideButton(element)

  enableSendToFriendButton: (buttons) ->
    buttons.on('click', (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data('product')
      popups.showSendToFriendPopup(productId, { analyticsLabel: window.product_analytics_label })
    )

  enableConciergeServiceButton: (buttons, itemId)->
    buttons.on('click', (e) ->
      e.preventDefault()
      
      popups.showConciergeServicePopup(itemId)
    )

  enableTwinAlertButton: (elements, get_color_func) ->
    window.helpers.initProductReserver(
      $(elements),
      window.product_analytics_label,
      get_color_func
    )

  enableAccordeonBars: (elements) ->
    hide = (elements_to_hide) ->
      elements_to_hide.find('.text').slideUp(500, () ->
        $(this).hide().closest('li').removeClass('opened')
      )
      elements_to_hide

    show = (elements_to_show) ->
      elements_to_show.find('.text').slideDown(500, () ->
        $(this).show().closest('li').addClass('opened')
      )
      elements_to_show

    scope = elements
    elements.on('click', '.title', (e) ->
      e.preventDefault()
      target = $(e.target).closest('li')

      if target.is('.opened')
        hide(scope)
      else
        hide(scope.filter('.opened').not(target))
        show(target)
        track.openedProductInfo(window.product_analytics_label)
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
      track.playedSong(window.product_analytics_label)
      return false
    )

  enablePersonalisatonForm: (container) ->
    if window.product_variants
      form = window.helpers.createPersonalisationForm(container)
      form.init(window.product_variants, window.product_master_variant, window.incompatibility_map)
      form

  enableProductImagesSlider: (container, input) ->
    if $(container).length > 0  and !!input
      window.helpers.createProductImagesSlider(container, input)
}

#window.processWishListLinks = () ->
#  $links = $('a.wish-list-link')
#
#  if _.isUndefined(window.current_user)
#    $links.data('action', 'auth-required')
#    $links.attr('href', '/login')
#  else
#    $links.data('action', 'add-to-wishlist')
#
#    unless _.isEmpty(window.current_user.wish_list)
#      $links.each (index, link) ->
#        $link = $(link)
#
#        wish = _.findWhere(window.current_user.wish_list, { variant_id: $link.data('id') })
#
#        unless _.isUndefined(wish)
#          $link.text('Remove from wishlist')
#          $link.addClass('active')
