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

  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  # show campaign - newsletter popup
  #if ($(".modal.campaign-newsletter.hide").length > 0)
  #  if $.cookie('newsletter_mp') != 'hide'
  #    showNewsletterPopup()
