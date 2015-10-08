window.helpers ||= {}
window.helpers.quickViewer = {
  popupContainer: null,
  overlayContainer: null,
  container: null,
  product_analytics_label: null

  init: () ->
    window.helpers.quickViewer.__init.apply(window.helpers.quickViewer, arguments)

  __init: () ->
    @container = window.popups.getQuickViewModalContainer(null, null)
    @popupContainer = @container.find('.product-page:first')
    @overlayContainer = @container.find('.overlay:first')
    @container.on('click', '.close-lightbox', @onCloseButtonHandler)
    @container.on('click', '.overlay', @onCloseButtonHandler)

  onCloseButtonHandler: (e) ->
    e.preventDefault()
    helpers.quickViewer.closePopup.call(helpers.quickViewer)

  onShowButtonHandler: (e) ->
    e.preventDefault()
    productId = $(e.currentTarget).data("id")
    helpers.quickViewer.showProduct.call(helpers.quickViewer, productId)

  showProduct: (productId) ->
    quickViewUrl = urlWithSitePrefix("/quick_view/#{productId}")
    $.ajax(
      url: quickViewUrl
      type: 'GET'
      dataType: 'json'
      data: $.param({ product_id: productId })
      success: (response) ->
        helpers.quickViewer.showPopup.call(helpers.quickViewer, response.popup_html, response.variants)
        if response.analytics_label
          helpers.quickViewer.product_analytics_label = response.analytics_label
          track.openedQuickView(response.analytics_label)
      failure: ->
        helpers.quickViewer.closePopup.call(helpers.quickViewer)
    )

  showPopup: (popup_html, product_variants) ->
    @popupContainer.replaceWith(popup_html)
    @popupContainer = @container.find('.product-page').first()
    @showProductImages(window.productImagesData) if window.productImagesData
    @overlayContainer.show()
    @popupContainer.show()
    @container.show()
    @movePopupToCenter()
    @updatePopupHandlers(product_variants)

  closePopup: () ->
    @popupContainer.hide()
    @overlayContainer.hide()
    @container.hide()

  showProductImages: (images) ->
    _.where(window.productImagesData, { size: null, color: null }).length

  updatePopupHandlers: (product_variants) ->
    window.helpers.enableTabs(helpers.quickViewer.container.find('.tabs'))

    # init product variants selector
    selector = window.helpers.createProductVariantsSelector(@container).init(product_variants)

    # add product to cart
    window.helpers.addBuyButtonHandlers(@popupContainer.find('.buy-wishlist .buy-now'))

    productWishlist.addWishlistButtonActions(
      @popupContainer.find(".buy-wishlist a[data-action='add-to-wishlist']")
    )

    @popupContainer.find('.toggle-sizes').fancybox({width: '1000', height: '410'})

    window.helpers.initProductReserver(
      @popupContainer.find('.twin-alert a.twin-alert-link'),
      helpers.quickViewer.product_analytics_label,
      selector
    )

    window.initProductImagesCarousel = (filterOptions = {}) ->
      $wrapper = helpers.quickViewer.container.find("#product-images")
      # populateImagesCarousel($wrapper, filterOptions)
      # show big images from carouseled small images
      options =
        prev:
          button: '#quick-view-product-images-up'
        next:
          button: '#quick-view-product-images-down'
      $wrapper.carouFredSel(
        helpers.get_vertical_carousel_options(options)
      )
      helpers.buildImagesViewer(helpers.quickViewer.container).init()

    window.initChosen = ->
      $('.selectbox').chosen
        width: '100%'
        disable_search: true

    # code should be executed after images loaded in order to correctly set carousel height
    @popupContainer.waitForImages(() ->
      initProductImagesCarousel()
      initChosen()
    )

    # track events on page
    createTrackHandler = (method) ->
      handler = (e) ->
        if !_.isEmpty(helpers.quickViewer.product_analytics_label)
          track[method].call(window, helpers.quickViewer.product_analytics_label)

    $(".tabs .tabs-links a[href='#inspiration']").on('click', createTrackHandler('viewCelebrityInspiration'))
    $('.buy-wishlist a.btn-layby').on('click', createTrackHandler('laybyButtonClick'))
    $('.product-info .customize a').on('click', createTrackHandler('customDressClick'))

  movePopupToCenter: () ->
    window.helpers.quickViewer.container.find('.quick-view').center()
}

