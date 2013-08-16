window.popups or= {}

#$('link').on('click', popups.showSendToFriendPopup)

window.popups.showSendToFriendPopup = (productId) ->

  # init
  if $('.modal.popup-placeholder').length == 0
    $('body.ecommerce #wrap #content').append(JST['templates/modal_popup']())
  else
    $('.modal.popup-placeholder').replaceWith(JST['templates/modal_popup']())

  # create popup
  popup = {
    container:  $('.modal.popup-placeholder')
    content:    $('.modal.popup-placeholder .modal-container')
    overlay:    $('.modal.popup-placeholder .overlay')
    productId:  productId

    init: () ->
      popup.container.find('.item').html(JST['templates/send_to_friend_form']())
      popup.container.find('.close-lightbox').on('click', popup.hide)
      popup.container.find('.save input.btn').on('click', popup.onButtonClick)

      popup.overlay.on('click', popup.hide)

      popup.container.find(".modal-title").text("Send to a friend")
      popup.container.find(".save input[type=submit]").val('Send')

      popup.container.find('#friend_name').on('change', _.debounce(popup.onInputChanged))
      popup.container.find('#friend_email').on('change', _.debounce(popup.onInputChanged))

    show: () ->
      popup.container.show().center()

    hide: () ->
      popup.container.hide()

    getFormData: () ->
      return {
        name: popup.container.find('#friend_name').val()
        email: popup.container.find('#friend_email').val()
        message: popup.container.find('#friend_message').val()
      }

    errorMessage: () ->
      $('<span>', {class: 'error', text: "Can't be empty"})

    formDataValid: () ->
      valid = true
      _.each(['name', 'email'], (name) ->
        input = popup.container.find("#friend_#{name}")
        valid = false unless popup.validateValue(input)
      )
      return valid

    onInputChanged: (e) ->
      popup.validateValue($(e.currentTarget))

    validateValue: (input) ->
      if _.isEmpty(input.val())
        input.addClass("error")
        popup.errorMessage().insertBefore(input)
        return false
      else
        input.removeClass("error")
        input.siblings('.error').remove()
        return true

    onButtonClick: (e) ->
      e.preventDefault()
      formData = popup.getFormData()

      if popup.formDataValid()
        $.ajax(
          url: "/products/#{popup.productId}/send_to_friend"
          type: 'POST'
          dataType: 'json'
          data: formData
          success: (data) ->
            data.success_message
        )
        popup.hide()
  }

  popup.init()
  popup.show()
  popup
