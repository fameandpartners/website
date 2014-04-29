window.popups or= {}

window.popups.LoginPopup = class LoginPopup
  constructor: (@options) ->
    @options or= {}
    _.bindAll(@, 'hide', 'show')
    _.bindAll(@, 'closeButtonClickHandler')
    _.bindAll(@, 'onButtonClick')

    @container = window.popups.getModalContainer('Login')

    @content = @container.find('.modal-container')
    @overlay = @container.find('.overlay')

    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)
    @container.addClass('login-popup')
    @container.find('.modal-container').addClass('form')
    @container.find('.save').addClass('submit')

    @container.on('click', '.save input.btn', @onButtonClick)
    @container.on('keyup', 'input', (e) ->
      @onButtonClick(e) if e.which == 13
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

  onButtonClick: (e) ->
    e.preventDefault()
    @loginUserRequest()
      .complete( () ->
        1 + 1
        debugger
        1 + 1
      )
    #  .done(@refreshPage)
    #  .fail(@hide)
    #

    #@hide()

  # helpers
  loginUserRequest: () ->
    formData = {
      spree_user: {
        email: @content.find('input#email_address'),
        password: @content.find('input#password')
      }
    }
    $.ajax(
      url: urlWithSitePrefix("/user/spree_user/sign_in")
      type: 'POST'
      dataType: 'json'
      data: $.param(formData)
    )
