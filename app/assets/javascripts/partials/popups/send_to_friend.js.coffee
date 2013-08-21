window.popups or= {}

#$('link').on('click', popups.showSendToFriendPopup)

window.popups.showSendToFriendPopup = (productId, options = {}) ->
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
    analyticsLabel: options.analyticsLabel
    guest: _.isEmpty(window.current_user)

    init: () ->
      templateData = { guest: popup.guest }
      popup.container.find('.item').html(JST['templates/send_to_friend_form'](templateData))
      popup.container.find('.close-lightbox').on('click', popup.hide)
      popup.container.find('.save input.btn').on('click', popup.onButtonClick)

      popup.overlay.on('click', popup.hide)

      popup.container.find(".modal-title").text("Send to a friend")
      popup.container.find(".save input[type=submit]").val('Send')

      popup.container.find('#sender_name').on('change', _.debounce(popup.onInputChanged))
      popup.container.find('#sender_email').on('change', _.debounce(popup.onInputChanged))
                                                                                           
      popup.container.find('#friend_name').on('change', _.debounce(popup.onInputChanged))
      popup.container.find('#friend_email').on('change', _.debounce(popup.onInputChanged))

      popup.container.addClass('send-to-friend')
      popup.container.find('.modal-container').addClass('form')
      popup.container.find('.save').addClass('submit')

    show: () ->
      popup.container.show().center()
      unless _.isEmpty(popup.analyticsLabel)
        track.openedSendToFriend(popup.analyticsLabel)

    successCallback: (data) ->
      #data.success_message
      unless _.isEmpty(popup.analyticsLabel)
        track.sentSendToFriend(popup.analyticsLabel)

    hide: () ->
      popup.container.hide()
      popup.container.removeClass('send-to-friend')
      popup.container.find('.modal-container').removeClass('form')
      popup.container.find('.save').removeClass('submit')

    getFormData: () ->
      return {
        sender_name: popup.container.find('#sender_name').val()
        sender_email: popup.container.find('#sender_email').val()
        name: popup.container.find('#friend_name').val()
        email: popup.container.find('#friend_email').val()
        message: popup.container.find('#friend_message').val()
      }

    errorMessage: () ->
      $('<span>', {
        class: 'error',
        text: "Can't be empty",
        style: 'font-size: small; color: red;'
      })

    formDataValid: () ->
      valid = true
      _.each(popup.container.find('input[required]'), (input) ->
        input = $(input)
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
          success: popup.successCallback
        )
        popup.hide()
  }

  popup.init()
  popup.show()
  popup
