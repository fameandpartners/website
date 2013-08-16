$('.pages.search').ready ->
  window.helpers.quickViewer.init()
  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
