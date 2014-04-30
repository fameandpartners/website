window.popups or= {}

window.popups.LoginPopup = class LoginPopup
  constructor: (@options) ->
    @options or= {}
    _.bindAll(@, 'hide', 'show')
    _.bindAll(@, 'closeButtonClickHandler', 'saveButtonClickHandler')

    @container = window.popups.getModalContainer('Login')

    @content = @container.find('.modal-container')
    @overlay = @container.find('.overlay')

    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)
    @container.addClass('login-popup')
    @container.find('.modal-container').addClass('form')
    @container.find('.save').addClass('submit')

    @container.on('click', '.save input.btn', @saveButtonClickHandler)
    @container.on('keyup', 'input', (e) ->
      @saveButtonClickHandler(e) if e.which == 13
    )

  # external api
  show: () ->
    formHtml = JST['templates/login_form']()
    @container.addClass('login-form').show()
    @container.find('.modal-container .item').addClass('modal-form').html(formHtml)
    @container.find('.modal-container').css({width: '670px'}).center()

  hide: () ->
    @container.hide()
    @container.off('keyup')
    @container.off('click')
    @

  # handlers
  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()

  saveButtonClickHandler: (e) ->
    e.preventDefault()
    @loginUserRequest()
      .done( (data, state) =>
        if data && !data.error && state == 'success'
          window.location.reload()
          @hide()
        else
          window.helpers.showErrors(@content.find('.item'), 'invalid login or password')
      )

  # helpers
  loginUserRequest: () ->
    formData = {
      spree_user: {
        email: @content.find('input#email_address').val(),
        password: @content.find('input#password').val()
      }
    }
    $.ajax(
      url: urlWithSitePrefix("/spree_user/sign_in")
      type: 'POST'
      dataType: 'json'
      data: $.param(formData)
    )
