window.helpers or= {}

window.helpers.ProductSideSelectorPanel = class ProductSideSelectorPanel
  constructor: ($container) ->
    @$container = $container
    @$overlay = $('#product-overlay').on('click', @close)
    @

  open: =>
    $('body').addClass('no-scroll')
    @$overlay.addClass('is-visible')
    @$container.addClass('speed-in')


  close: =>
    @$container.removeClass('speed-in')
    @$overlay.removeClass('is-visible')
    $('body').removeClass('no-scroll')
    @$container.find('.close-btn').on('click', @close)
    @close.removeClass('is-visible')
