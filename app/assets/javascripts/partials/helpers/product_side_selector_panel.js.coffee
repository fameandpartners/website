window.helpers or= {}

window.helpers.ProductSideSelectorPanel = class ProductSideSelectorPanel
  constructor: ($container) ->
    @$container = $container
    @$overlay = $('#product-overlay').on('click', @close)
    @$container.find('.close-btn').on('click', @close)

  open: =>
    @$overlay.addClass('is-visible')
    @$container.addClass('speed-in')
    @blockScroll()

  close: =>
    @$container.removeClass('speed-in')
    @$overlay.removeClass('is-visible')
    @unblockScroll()

  blockScroll: ->
    document.body.style.overflow = "hidden"

  unblockScroll: ->
    document.body.style.overflow = ""
