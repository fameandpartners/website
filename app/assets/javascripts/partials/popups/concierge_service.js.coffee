window.popups or= {}

window.popups.showConciergeServicePopup = (itemId) ->
  popup = {
    init: () ->
      popup.container = popups.getVanillaModalContainer('modal_concierge').addClass('consierge-service')
      popup.content = popup.container.find('.modal-container').addClass('form')
      popup.overlay = popup.container.find('.overlay')
      popup.container.on('click', '.close-lightbox, .overlay', popup.hide)
      popup.container.find('.item').html(JST['templates/bridesmaid_concierge'])

      popup.container.on('click', 'a.block-with-triangle', popup.onButtonClick)

    show: () ->
      popup.container.show()
      popup.content.center()

    hide: () ->
      popup.container.hide()
      $.cookie('concierge_service_mp', 'hide', { expires: 365, path: '/' })
      popup.container.removeClass('consierge-service')
      popup.container.find('.modal-container').removeClass('form')

    isFormValid: () ->
      form = $('form.concierge')[0]
      if _.isFunction(form.checkValidity) && form.checkValidity()
        return true
      else
        popup.markInputAsInvalid(popup.container.find('input#phone_number'))
        popup.markInputAsInvalid(popup.container.find('input#user_email'))
        popup.markInputAsInvalid(popup.container.find('input#suburb_state'))
        return false

    markInputAsInvalid: (input, msg = "invalid") ->
      if _.isEmpty(input.val())
        window.helpers.showErrors(input.closest('.input'), msg)

    onButtonClick: (e) ->
      e.preventDefault()
      return false unless popup.isFormValid()

      u_phone = popup.container.find('input#phone_number').val()
      u_email = popup.container.find('input#user_email').val()
      u_suburb_state = popup.container.find('input#suburb_state').val()

      $.ajax({
        url:      urlWithSitePrefix("/bridesmaid-party/additional_products/consierge_service"),
        type:     "POST",
        dataType: "json",
        data: {user_info: {phone: u_phone, email: u_email, suburb_state: u_suburb_state}},
        success: window.shopping_cart.buildOnSuccessCallback(["item_added", "item_changed"], itemId)
      })

      popup.hide()


  }
  popup.init()
  popup.show()
  popup
