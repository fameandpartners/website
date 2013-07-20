window.helpers or= {}
window.helpers.quickViewer = {
  popupContainer: null,
  overlayContainer: null,
  container: null,

  init: () ->
    window.helpers.quickViewer.__init.apply(window.helpers.quickViewer, arguments)

  __init: () ->
    if !@popupContainer? and !@overlayContainer?
      popupPlaceholderHtml = "
        <div class='quick-view-mode modal'>
          <div class='overlay'></div>
          <div class='quick-view'>
            <div class='close-lightbox'></div>
            <div class='product-page grid-container'></div>
          </div>
        </div>"
      $('#content').append(popupPlaceholderHtml)
      @container = $('#content .quick-view-mode ').first().hide()
      @popupContainer = @container.find('.product-page').first().hide()
      @overlayContainer = @container.find('.overlay').first().hide()
    # init
    $('.close-lightbox').on('click', @onCloseButtonHandler)

  onCloseButtonHandler: (e) ->
    e.preventDefault()
    helpers.quickViewer.closePopup.call(helpers.quickViewer)

  onShowButtonHandler: (e) ->
    e.preventDefault()
    productId = $(e.currentTarget).data("id")
    helpers.quickViewer.showProduct.call(helpers.quickViewer, productId)

  onBuyButtonClickHandler: (e) ->
    e.preventDefault()
    button = $(e.currentTarget)
    button.addClass('adding')
    window.shopping_cart.addProduct(button.data('variant_id'), {
      failure: () -> button.removeClass('adding')
      success: () -> button.removeClass('adding').addClass('added')
    })

  showProduct: (productId) ->
    $.ajax(
      url: "/products/#{productId}/quick_view"
      type: 'GET'
      dataType: 'json'
      data: $.param({ product_id: productId })
      success: (response) ->
        helpers.quickViewer.showPopup.call(helpers.quickViewer, response.popup_html, response.variants)
      failure: ->
        helpers.quickViewer.closePopup.call(helpers.quickViewer)
    )

  showPopup: (popup_html, product_variants) ->
    @popupContainer.replaceWith(popup_html)
    @popupContainer = @container.find('.product-page').first()
    @overlayContainer.show()
    @popupContainer.show()
    @container.show()
    @movePopupToCenter()
    @overlayContainer.one('click', @onCloseButtonHandler)
    @updatePopupHandlers(product_variants)

  closePopup: () ->
    @popupContainer.hide()
    @overlayContainer.hide()
    @container.hide()

  updatePopupHandlers: (product_variants) ->
    window.helpers.enableTabs(@container.find('.tabs'))

    # show big images from carouseled small images
    container = @container
    options =
      prev:
        button: '#quick-view-product-images-up'
      next:
        button: '#quick-view-product-images-down'
    setTimeout () ->
        container.find("#product-images").carouFredSel(
          window.helpers.get_vertical_carousel_options(options)
        )
        viewer = window.helpers.buildImagesViewer(container).init()
      , 100

    # init product variants selector
    selector = window.helpers.createProductVariantsSelector(@container).init(product_variants)

    # add product to cart
    @popupContainer.find('.buy-wishlist .buy-now').on('click', window.helpers.quickViewer.onBuyButtonClickHandler)
    productWishlist.addWishlistButtonActions(@popupContainer.find(".buy-wishlist .add-wishlist"))

  movePopupToCenter: () ->
    window.helpers.quickViewer.container.center()
}

