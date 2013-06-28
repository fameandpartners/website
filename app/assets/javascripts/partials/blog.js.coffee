$ ->
  $(".blog-slider .slides").carouFredSel
    circular: false
    infinite: false
    responsive: true
    auto: false
    scroll:
      fx: "slide"

    pagination: ".blog-slider .pagination"

  $("#post-carousel").carouFredSel
    circular: true
    infinite: true
    items: 1
    auto: false
    prev:
      button  : "#post-carousel-prev"
      key   : "left"

    next:
      button  : "#post-carousel-next"
      key   : "right"
