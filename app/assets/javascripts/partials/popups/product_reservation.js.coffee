window.popups or= {}

window.popups.ProductReservationPopup = class ProductReservationPopup
  fields: [
    'first_name',
    'last_name',
    'email',
    'password',
    'password_confirmation',
    'school_name',
    'formal_name',
    'school_year'
  ]
  constructor: (@options, @completeCallback) ->
    @options or= {}
    _.bindAll(@, 'hide', 'show', 'showModalWindow')
    _.bindAll(@, 'closeButtonClickHandler')
    _.bindAll(@, 'onButtonClick', 'onInputChanged', 'successCallback')
    _.bindAll(@, 'validateValue', 'formDataValid')

    @container = window.popups.getModalContainer('Reserve this Dress', 'Register Now')

    @content = @container.find('.modal-container')
    @overlay = @container.find('.overlay')

    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)
    @container.addClass('send-to-friend')
    @container.find('.modal-container').addClass('form')
    @container.find('.save').addClass('submit')

    @container.on('click', '.save input.btn', @onButtonClick)
    @container.on('keyup', 'input', (e) ->
      @onButtonClick(e) if e.which == 13
    )

  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()

  show: () ->
    guest = _.isEmpty(window.current_user)
    currentYear = new Date().getFullYear()
    templateData = {
      school_name: @options.schoolName,
      formal_name: @options.formalName,
      school_year: @options.schoolYear,
      guest: guest,
      years: [currentYear..(currentYear+5)]
    }
    @container.find('.item').html(JST['templates/product_reservation_form'](templateData))
    if guest
      @container.find('.description.guest').show()
    else
      @container.find('.description.member').show()

    _.each(@fields, (id) ->
      @container.find("##{id}").on('change', @onInputChanged)
    , @)
    @showModalWindow()

  showModalWindow: () ->
    @container.show()
    @content.center()
    @container.find('select').val(@options.schoolYear).chosen()
    track.twinAlertOpen(@options.label)

  hide: () ->
    @container.hide()
    @container.removeClass('send-to-friend')
    @container.find('.modal-container').removeClass('form')
    @container.find('.save').removeClass('submit')

  getFormData: () ->
    result = {user: {}, reservation: {}}

    _.each(['first_name', 'last_name', 'email', 'password', 'password_confirmation'], (name) ->
      result.user[name] = @container.find("##{name}").val()
    , @)

    _.each(['school_name', 'formal_name', 'school_year'], (name) ->
      result.reservation[name] = @container.find("##{name}").val()
    , @)
    result.reservation.product_id = @options.productId
    result.reservation.color = @options.color
    result

  errorMessage: (errorText = "Can't be empty") ->
    $('<span>', {
      class: 'error',
      text: errorText,
      style: 'font-size: small; color: red;'
    })

  formDataValid: () ->
    valid = true
    _.each(@container.find('input[required]'), (input) ->
      input = $(input)
      valid = false unless @validateValue(input)
    , @)
    return valid

  onInputChanged: (e) ->
    @validateValue($(e.currentTarget))

  validateValue: (input) ->
    input.removeClass("error")
    input.siblings('.error').remove()

    if _.isEmpty(input.val())
      input.addClass("error")
      @errorMessage().insertBefore(input)
      return false
    else
      return true

  onButtonClick: (e) ->
    e.preventDefault()
    formData = @getFormData()

    if @formDataValid()
      $.ajax(
        url: urlWithSitePrefix("/product_reservations")
        type: 'POST'
        dataType: 'json'
        data: formData
        success: @successCallback
      )

  successCallback: (data) ->
    if data.user && _.isEmpty(window.current_user)
      window.current_user = data.user
      @user_created = true
      @container.find('.member-fields.guest').hide()
      @container.find('.description.guest').hide()
      @container.find('.description.member').show()

    if data.success
      track.twinAlertRegister(@options.label)
      @hide()
      if @user_created
        window.location = window.location = window.location
      @completeCallback.call(window, data.message) if @completeCallback
    else
      _.each(_.keys(data.errors), (name) ->
        input = @container.find("input##{name}")
        input.addClass("error")
        @errorMessage(data.errors[name]).insertBefore(input)
      ,@)

#----------------------------------------------------------------------------------------------------
#window.popups or= {}
#
#window.popups.showProductReservationPopup = (options, callback = null) ->
#  completeCallback = callback
#
#  fields = [
#    'first_name',
#    'last_name',
#    'email',
#    'password',
#    'password_confirmation',
#    'school_name',
#    'formal_name',
#    'school_year'
#  ]
#
#  # init
#  if $('.modal.popup-placeholder').length == 0
#    $('body.ecommerce #wrap #content').append(JST['templates/modal_popup']())
#  else
#    $('.modal.popup-placeholder').replaceWith(JST['templates/modal_popup']())
#
#  # create popup
#  popup = {
#    container:  $('.modal.popup-placeholder')
#    content:    $('.modal.popup-placeholder .modal-container')
#    overlay:    $('.modal.popup-placeholder .overlay')
#    guest: _.isEmpty(window.current_user)
#    options: options
#
#    init: () ->
#      currentYear = new Date().getFullYear()
#      templateData = {
#        school_name: popup.options.schoolName,
#        formal_name: popup.options.formalName,
#        school_year: popup.options.schoolYear,
#        guest: popup.guest,
#        years: [currentYear..(currentYear+5)]
#      }
#      popup.container.find('.item').html(JST['templates/product_reservation_form'](templateData))
#      if popup.guest
#        popup.container.find('.description.guest').show()
#      else
#        popup.container.find('.description.member').show()
#
#      popup.container.addClass('send-to-friend')
#      popup.container.find('.close-lightbox').on('click', popup.hide)
#      popup.container.find('.save input.btn').on('click', popup.onButtonClick)
#
#      popup.overlay.on('click', popup.hide)
#
#      popup.container.find(".modal-title").text("Twin Alert")
#      popup.container.find(".save input[type=submit]").val('Register Now')
#
#      _.each(fields, (id) -> $("##{id}").on('change', _.debounce(popup.onInputChanged)))
#      
#      popup.container.find('.modal-container').addClass('form')
#      popup.container.find('.save').addClass('submit')
#
#      popup.container.find('input').on('keyup', (e) ->
#        popup.onButtonClick(e) if e.which == 13
#      )
#
#    show: () ->
#      popup.container.show()
#      popup.content.center()
#      popup.container.find('select').val(popup.options.schoolYear).chosen()
#      track.twinAlertOpen(popup.options.label)
#
#    successCallback: (data) ->
#      if data.user && _.isEmpty(window.current_user)
#        window.current_user = data.user
#        popup.user_created = true
#        popup.container.find('.member-fields.guest').hide()
#        popup.container.find('.description.guest').hide()
#        popup.container.find('.description.member').show()
#
#      if data.success
#        track.twinAlertRegister(popup.options.label)
#        popup.hide()
#        if popup.user_created
#          window.location = window.location = window.location
#        completeCallback.call(window, data.message) if completeCallback
#        popup = null
#      else
#        _.each(_.keys(data.errors), (name) ->
#          input = $("input##{name}")
#          input.addClass("error")
#          popup.errorMessage(data.errors[name]).insertBefore(input)
#        )
#
#    hide: () ->
#      popup.container.hide()
#      popup.container.removeClass('send-to-friend')
#      popup.container.find('.modal-container').removeClass('form')
#      popup.container.find('.save').removeClass('submit')
#
#    getFormData: () ->
#      result = {user: {}, reservation: {}}
#
#      _.each(['first_name', 'last_name', 'email', 'password', 'password_confirmation'], (name) ->
#        result.user[name] = popup.container.find("##{name}").val()
#      )
#
#      _.each(['school_name', 'formal_name', 'school_year'], (name) ->
#        result.reservation[name] = popup.container.find("##{name}").val()
#      )
#      result.reservation.product_id = popup.options.productId
#      result.reservation.color = popup.options.color
#      result
#
#    errorMessage: (errorText = "Can't be empty") ->
#      $('<span>', {
#        class: 'error',
#        text: errorText,
#        style: 'font-size: small; color: red;'
#      })
#
#    formDataValid: () ->
#      valid = true
#      _.each(popup.container.find('input[required]'), (input) ->
#        input = $(input)
#        valid = false unless popup.validateValue(input)
#      )
#      return valid
#
#    onInputChanged: (e) ->
#      popup.validateValue($(e.currentTarget))
#
#    validateValue: (input) ->
#      input.removeClass("error")
#      input.siblings('.error').remove()
#
#      if _.isEmpty(input.val())
#        input.addClass("error")
#        popup.errorMessage().insertBefore(input)
#        return false
#      else
#        return true
#
#    onButtonClick: (e) ->
#      e.preventDefault()
#      formData = popup.getFormData()
#
#      if popup.formDataValid()
#        $.ajax(
#          url: urlWithSitePrefix("/product_reservations")
#          type: 'POST'
#          dataType: 'json'
#          data: formData
#          success: popup.successCallback
#        )
#  }
#
#  popup.init()
#  popup.show()
#  popup
