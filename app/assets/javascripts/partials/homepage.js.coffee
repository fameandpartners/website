$(".index.show").ready ->

  # enable carousel
  carousel = $("#product-items").carouFredSel
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

  # scrolling featured images
