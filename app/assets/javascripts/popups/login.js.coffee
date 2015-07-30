#= require templates/login_popup

window.popups or= {}
window.popups.Login = class Login
  constructor: (@opts = {}) ->
    @path = @opts.path || window.location.href

  open: () ->
    formSubmit = @formSubmit
    @$content = vex.dialog.open
      message: ''
      input: JST['templates/login_popup'](
        fb_auth_path: urlWithSitePrefix("/fb_auth?return_to=#{ encodeURIComponent(@path) }")
      ),
      className: 'vex-dialog-default vex-dialog-center',
      buttons: []
      afterOpen: ($vexcontent) =>
        $vexcontent.find('form').on('submit', formSubmit)
        $vexcontent.find('input[type=submit]').on('click', formSubmit)
    @$content

  hide: () =>
    vex.close(@$content.data().vex.id)

  formSubmit: (e) =>
    e.preventDefault()
    @loginUserRequest()
      .done( (data, state) =>
        if data && !data.error && state == 'success'
          window.location.reload()
          @hide()
        else
          window.helpers.showErrors(@$content.find('.item'), 'invalid login or password')
      )

  # helpers
  loginUserRequest: () =>
    formData = {
      spree_user: {
        email: @$content.find('input#email_address').val(),
        password: @$content.find('input#password').val()
      }
    }
    $.ajax(
      url: urlWithSitePrefix("/spree_user/sign_in")
      type: 'POST'
      dataType: 'json'
      data: $.param(formData)
    )
