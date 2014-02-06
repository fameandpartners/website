$(".index.show").ready ->

  # enable products scroll
  $(".featured#product-items").carouFredSel(
    window.helpers.get_horizontal_carousel_options(
      infinite: true,
      circular: true,
      height: 458
    )
  )

  $("#main-promo .slides").carouFredSel(
    infinite: true,
    circular: true,
    auto: 5000,
    width: 1078,
    pagination: '#main-promo .pagination',
    items:
      visible: 1,
      width: 1078,
      height: 532
  )

  # add quick view feature
  window.helpers.quickViewer.init()

  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)

  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  # show campaign - newsletter popup
  if ($(".modal.campaign-newsletter.hide").length > 0)
    if $.cookie('newsletter_mp') != 'hide'
      $popupWrapper = $(".campaign-newsletter")
      $popupContent = $popupWrapper.find('.modal-container')
      popup = new window.popups.newsletterModalPopup()
      popup.initialize($popupWrapper.first())
      popup.show()
      $popupContent.center()
      window.newsletterModalPopup = popup
      popup
