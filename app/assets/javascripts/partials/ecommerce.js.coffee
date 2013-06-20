$ ->
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

  $(".shopping-bag-popup").hide()
  $(".shopping-bag-toggler").on "click", ->
    $(".shopping-bag-popup").slideToggle "slow"
    false

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

  $(".cart-page .details .edit-link").on "click", ->
    $(this).parent().parent().parent().find('.static').fadeToggle()
    $(this).parent().parent().parent().find('.dynamic').fadeToggle()
    false