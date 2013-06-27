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
    auto: true
    width: 644
    height: 355
