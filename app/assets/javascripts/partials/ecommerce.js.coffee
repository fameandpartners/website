$ ->

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
