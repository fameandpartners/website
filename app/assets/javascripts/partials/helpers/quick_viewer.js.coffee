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
      @container = $('#content .quick-view-mode ')
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
    @updatePopupHandlers(product_variants)
    @overlayContainer.show()
    @popupContainer.show()
    @movePopupToCenter()

  closePopup: () ->
    @popupContainer.hide()
    @overlayContainer.hide()

  updatePopupHandlers: (product_variants) ->
    @popupContainer.find("#product-images").carouFredSel(
      window.helpers.get_vertical_carousel_options()
    )
    window.helpers.enableTabs($('.tabs'))

    viewer = window.helpers.buildImagesViewer()
    # init viewing big images
    $('#photos .big-photo .zoom a').on('click', viewer.showFullImageEventHandler)
    # init showing images from element
    $('ul#product-images li a').on("click", viewer.onClickHandler)
    viewer.showImageFromItem($('ul#product-images li a').first())
    # init product variants selector
    selector = window.helpers.createProductImagesSelector().init(product_variants)

  movePopupToCenter: () ->
    window.helpers.quickViewer.container.center()
}

# helper methods
jQuery.fn.center = () ->
  @css("position","absolute")
  @css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                           $(window).scrollTop()) + "px")
  @css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                            $(window).scrollLeft()) + "px")
