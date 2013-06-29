$(".products, .index.show").ready ->

  window.quickViewer = {
    popupContainer: null,
    overlayContainer: null,

    init: () ->
      if !popupContainer? and !overlayContainer?
        popupPlaceholderHtml = "
          <div class='quick-view-mode modal'>
            <div class='overlay'></div>
            <div class='quick-view'>
              <div class='close-lightbox'></div>
              <div class='product-page grid-container'></div>
            </div>
          </div>"
        $('#content').append(popupPlaceholderHtml)
        quickViewer.popupContainer = $('#content .quick-view-mode .product-page').first().hide()
        quickViewer.overlayContainer = $('#content .quick-view-mode .overlay').first().hide()
      # init
      $('.close-lightbox').on('click', quickViewer.onCloseButtonHandler)

    onCloseButtonHandler: (e) ->
      e.preventDefault()
      quickViewer.closePopup.call(quickViewer)

    onShowButtonHandler: (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      quickViewer.showProduct.call(quickViewer, productId)

    showProduct: (productId) ->
      $.ajax(
        url: "/products/#{productId}/quick_view"
        type: 'GET'
        dataType: 'json'
        data: $.param({ product_id: productId })
        success: (response) ->
          quickViewer.showPopup.call(quickViewer, response.popup_html, response.variants)
        failure: ->
          quickViewer.closePopup.call(quickViewer)
      )

    showPopup: (popup_html, product_variants) ->
      @popupContainer.replaceWith(popup_html).show()
      @popupContainer = $('#content .quick-view-mode .product-page').first()
      @overlayContainer.show()

    closePopup: () ->
      @popupContainer.hide()
      @overlayContainer.hide()
  }

  quickViewer.init()
  $(".quick-view a[data-action='quick-view']").on('click', quickViewer.onShowButtonHandler)
