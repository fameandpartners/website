$(".products.show").ready ->
  page.enableShoppingCart()
  page.enableProductVariantsSelector($('#content .product-info'))
  page.enableQuickView($(".quick-view a[data-action='quick-view']"))
  page.enableWhatSizeIam($('.toggle-sizes'))
  page.enableBuyButton($('.buy-now'), { expandShoppingBag: true})
  page.enableSendToFriendButton($('a.send-to-friend'))
  page.enableAccordeonBars($('ul.slider li'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))

#window.populateImagesCarousel = ($wrapper, filterOptions = {}) ->
#  $wrapper.empty()
#  hasAny = _(filterOptions).keys().length == 0 || _(window.productImagesData).any (data) ->
#    filterOptions.color && data.color == filterOptions.color
#  filterOptions = {} unless hasAny
#  _(window.productImagesData).each (data) ->
#    if (!filterOptions.color || data.color == filterOptions.color)
#      $img = $('<img />', width: 83, height: 115, alt: '', src: data.small)
#      $link = $('<a/>', href: '#', data: data).html($img)
#      $wrapper.append($('<li/>').html($link))
#
#$(".products.show").ready ->
#  window.shopping_cart.init(window.bootstrap)
#
#  # enable product main tabs
#  window.helpers.enableTabs($('.tabs'))
#
#  # carousel for similar or related products
#  carousel = $("#product-items").carouFredSel(
#    window.helpers.get_horizontal_carousel_options()
#  )
#  # enable images carousel
#  window.initProductImagesCarousel = (filterOptions = {}) ->
#    $wrapper = $("#product-images")
#    populateImagesCarousel($wrapper, filterOptions)
#
#    $wrapper.carouFredSel(
#      window.helpers.get_vertical_carousel_options(
#        width: 83
#        height: 528
#        items:
#          start: 0
#          visible: 4
#          height: 132
#        scroll:
#          items: 1
#      )
#    )
#
#    # show big images from carouseled small images
#    viewer = null
#    viewer = window.helpers.buildImagesViewer($('#content .wrap')).init()
#
#  initProductImagesCarousel()
#
#  # enable color-size combination selection
#  if window.product_variants
#    variantsSelector = window.helpers.createProductVariantsSelector($('#content .product-info'))
#    variantsSelector.init(window.product_variants)
#
#  # add quick view feature
#  window.helpers.quickViewer.init()
#  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
#
#  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
#
#  window.initHoverableProductImages()
#
#  # what size i'm
#  $('.toggle-sizes').fancybox({width: '1000', height: '183'})
#
#  window.helpers.addBuyButtonHandlers($('.buy-now'), { expandShoppingBag: true})
#
#  # send to friend
#  $('a.send-to-friend').on('click', (e) ->
#    e.preventDefault()
#    productId = $(e.currentTarget).data('product')
#    popups.showSendToFriendPopup(productId, { analyticsLabel: window.product_analytics_label })
#  )
#
#  window.helpers.addCustomizationButtonHandlers($('#customize-dress-button'))
#
#  window.helpers.addPersonalizationFormHandlers($('#personalization')) if $('#personalization').size() isnt 0
#
#  window.helpers.initProductReserver(
#    $('.twin-alert a.twin-alert-link'),
#    window.product_analytics_label,
#    variantsSelector
#  )
#
#  # track events on page
#  createTrackHandler = (method) ->
#    handler = (e) ->
#      if !_.isEmpty(window.product_analytics_label)
#        track[method].call(window, window.product_analytics_label)
#
#  $(".tabs .tabs-links a[href='#videos']").on('click', createTrackHandler('viewVideo'))
#  $(".tabs .tabs-links a[href='#inspiration']").on('click', createTrackHandler('viewCelebrityInspiration'))
#  $('.buy-wishlist a.btn-layby').on('click', createTrackHandler('laybyButtonClick'))
#  $('.product-info .customize a').on('click', createTrackHandler('customDressClick'))
#  $(document).on 'click', '#ask-parent-to-pay-button', (e) ->
#    e.preventDefault()
#    variantId = $('.buy-now').data('id')
#
#    if variantId?
#      paymentRequestModal.show(variantId)
#    else
#      window.helpers.showErrors($(e.currentTarget).parent(), 'Please, select size and colour')
#
#  # toggle accordeon bars on right
#  $('ul.slider li').on('click', (e) ->
#    $(e.target).closest('li').toggleClass('opened')
#  )
