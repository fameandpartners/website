$('.index.show').ready ->
  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  # show campaign - newsletter popup
  #if ($(".modal.campaign-newsletter.hide").length > 0)
  #  if $.cookie('newsletter_mp') != 'hide'
  #    showNewsletterPopup()
