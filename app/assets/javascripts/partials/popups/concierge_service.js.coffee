window.popups or= {}

window.popups.showConciergeServicePopup = (itemId) ->
  popup = {
    init: () ->
      popup.container = popups.getModalContainer("Consierge", 'Buy now!').addClass('consierge-service')
      popup.content = popup.container.find('.modal-container').addClass('form')
      popup.overlay = popup.container.find('.overlay')
      popup.container.on('click', '.close-lightbox, .overlay', popup.hide)
      popup.container.find('.item').html(JST['templates/bridesmaid_concierge'])

      popup.container.on('click', '.save input.btn', popup.onButtonClick)

    show: () ->
      popup.container.show()
      popup.content.center()

    hide: () ->
      popup.container.hide()
      popup.container.removeClass('consierge-service')
      popup.container.find('.modal-container').removeClass('form')

    onButtonClick: (e) ->
      e.preventDefault();

      $.ajax({
        url:      urlWithSitePrefix("/bridesmaid-party/additional_products/consierge_service"),
        type:     "POST",
        dataType: "json",
        success: window.shopping_cart.buildOnSuccessCallback(["item_added", "item_changed"], itemId)
      });

      popup.hide()


  }
  popup.init()
  popup.show()
  popup