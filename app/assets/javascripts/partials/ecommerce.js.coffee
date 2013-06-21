$ ->
  # Shopping bag in header carousel
  $("#shopping-bag-popup").carouFredSel
    direction: "up"
    items: 2
    circular: false
    infinite: false
    auto: false
    prev:
      button: "#shopping-arrow-up"
      key: "up"
      items: 2

    next:
      button: "#shopping-arrow-down"
      key: "down"
      items: 2

  # Toggle shopping bag in header
  $("#shopping-bag-popup-wrapper").hide()
  $(".shopping-bag-toggler").on "click", ->
    $("#shopping-bag-popup-wrapper").slideToggle "slow"
    false

  # Single product page images carousel
  $("#product-images").carouFredSel
    direction: "up"
    items: 4
    circular: false
    infinite: false
    auto: false
    prev:
      button: "#product-images-up"
      key: "up"
      items: 4

    next:
      button: "#product-images-down"
      key: "down"
      items: 4

  # Edit product item details in cart
  $(".cart-page .details .edit-link").on "click", ->
    $(this).parent().parent().parent().find('.static').fadeToggle()
    $(this).parent().parent().parent().find('.dynamic').fadeToggle()
    false

  # Products carousel on frontpage
  $("#product-items").carouFredSel
    items: 4
    width: 1094
    circular: false
    infinite: false
    auto: false
    prev:
      button: "#product-items-prev"
      key: "left"
      items: 4

    next:
      button: "#product-items-next"
      key: "right"
      items: 4