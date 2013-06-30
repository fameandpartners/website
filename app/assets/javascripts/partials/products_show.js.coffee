$(".products.show").ready ->
  # enable product main tabs
  window.helpers.enableTabs($('.tabs'))

  # carousel for similar or related products
  carousel = $("#product-items").carouFredSel(window.helpers.get_horizontal_carousel_options())

  # show big images from carouseled small images
  viewer = window.helpers.buildImagesViewer()
  $('ul#product-images li a').on("click", viewer.onClickHandler)
  viewer.showImageFromItem($('ul#product-images li a').first())

  # show big images
  $('#photos .big-photo .zoom a').on('click', viewer.showFullImageEventHandler)

  # enable color-size combination selection
  if window.product_variants
    variantsSelector = window.helpers.createProductImagesSelector()
    variantsSelector.init(window.product_variants)
