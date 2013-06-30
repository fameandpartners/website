$(".index.show").ready ->
  # enable products scroll
  $("#product-items").carouFredSel(window.helpers.get_horizontal_carousel_options())

  # add quick view feature
  window.helpers.quickViewer.init()
  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
