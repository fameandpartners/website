$(".products.show").ready ->
  # enable product main tabs
  window.helpers.enableTabs($('.tabs'))

  # carousel for similar or related products
  carousel = $("#product-items").carouFredSel(window.helpers.get_horizontal_carousel_options())

  # show big images from carouseled small images
  viewer = window.helpers.buildImagesViewer($('#content .wrap')).init()

  # enable color-size combination selection
  if window.product_variants
    variantsSelector = window.helpers.createProductImagesSelector($('#content .wrap'))
    variantsSelector.init(window.product_variants)

  # add quick view feature
  window.helpers.quickViewer.init()
  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)

