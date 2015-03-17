window.popups or= {}

#$('link').on('click', popups.showSendToFriendPopup)

window.popups.showSendToFriendPopup = (productId, options = {}) ->
  # create popup
  popup = {
    productId:  productId
    analyticsLabel: options.analyticsLabel
    guest: _.isEmpty(window.current_user)

    init: () ->
      popup.container = popups.getModalContainer("Second Opinion", 'Send').addClass('send-to-friend')
      popup.content = popup.container.find('.modal-container').addClass('form')
      popup.overlay = popup.container.find('.overlay')

      popup.container.on('click', '.close-lightbox, .overlay', popup.hide)

      templateData = { guest: popup.guest }
      popup.container.find('.item').html(JST['templates/send_to_friend_form'](templateData))

      popup.container.on('change', '#sender_email, #friend_email', _.debounce(popup.onInputChanged))
      popup.container.on('click', '.save input.btn', popup.onButtonClick)

    show: () ->
      popup.container.show()
      popup.content.center()
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

    getFormData: () ->
      return {
        sender_email: popup.container.find('#sender_email').val()
        email: popup.container.find('#friend_email').val()
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
      input.siblings('.error').remove()
      if _.isEmpty(input.val())
        input.addClass("error")
        popup.errorMessage().insertBefore(input)
        return false
      else
        input.removeClass("error")
        return true

    onButtonClick: (e) ->
      e.preventDefault()
      formData = popup.getFormData()

      if popup.formDataValid()
        $.ajax(
          url: urlWithSitePrefix("/products/#{popup.productId}/send_to_friend")
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
