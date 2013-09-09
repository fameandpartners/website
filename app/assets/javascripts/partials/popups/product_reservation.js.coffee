window.popups or= {}

window.popups.showProductReservationPopup = (productId, color, callback = null) ->
  completeCallback = callback

  fields = [
    'first_name',
    'last_name',
    'email',
    'password',
    'password_confirmation',
    'school_name',
    'formal_name',
    'school_year'
  ]

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
    guest: _.isEmpty(window.current_user),
    productId: productId,
    color: color

    init: () ->
      currentYear = new Date().getFullYear()
      templateData = { guest: popup.guest, years: [currentYear..(currentYear+5)] }
      popup.container.find('.item').html(JST['templates/product_reservation_form'](templateData))
      popup.container.find('.close-lightbox').on('click', popup.hide)
      popup.container.find('.save input.btn').on('click', popup.onButtonClick)

      popup.overlay.on('click', popup.hide)

      popup.container.find(".modal-title").text("Twin Alert")
      popup.container.find(".save input[type=submit]").val('Register Now')

      _.each(fields, (id) -> $("##{id}").on('change', _.debounce(popup.onInputChanged)))
      
      popup.container.find('.modal-container').addClass('form')
      popup.container.find('.save').addClass('submit')

      popup.container.find('input').on('keyup', (e) ->
        popup.onButtonClick(e) if e.which == 13
      )

    show: () ->
      popup.container.show().center()
      popup.container.find('select').chosen()

    successCallback: (data) ->
      if data.success
        popup.hide()
        popup = null
        completeCallback.call() if completeCallback
      else
        _.each(data.errors, (name) ->
          input = $("input##{name}")
          input.addClass("error")
          popup.errorMessage("Please, check this value").insertBefore(input)
        )

    hide: () ->
      popup.container.hide()
      popup.container.removeClass('send-to-friend')
      popup.container.find('.modal-container').removeClass('form')
      popup.container.find('.save').removeClass('submit')

    getFormData: () ->
      result = {user: {}, reservation: {}}

      _.each(['first_name', 'last_name', 'email', 'password', 'password_confirmation'], (name) ->
        result.user[name] = popup.container.find("##{name}").val()
      )

      _.each(['school_name', 'formal_name', 'school_year'], (name) ->
        result.reservation[name] = popup.container.find("##{name}").val()
      )
      result.reservation.product_id = popup.productId
      result.reservation.color = popup.color
      result

    errorMessage: (errorText = "Can't be empty") ->
      $('<span>', {
        class: 'error',
        text: errorText,
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
          url: "/product_reservations"
          type: 'POST'
          dataType: 'json'
          data: formData
          success: popup.successCallback
        )
  }

  popup.init()
  popup.show()
  popup
