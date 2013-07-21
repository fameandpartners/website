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
