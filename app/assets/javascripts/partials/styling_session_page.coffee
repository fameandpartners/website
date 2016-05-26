frm = $('#new_style_session')
submit_btn = $('.form-global .submit input')
frm.submit (ev) ->
  $.ajax
    type: 'post'
    url: frm.attr('action')
    data: frm.serialize()
    beforeSend: ->
      submit_btn.val 'Sending...'
      $(".form-global label.error").remove()
      return
    success: (data) ->
      console.log(data)
      if (data.success)
        $(".form-area .not-submitted").css("display", "none")
        $(".form-area .confirmation").css("display", "block")
      else
        submit_btn.val 'Confirm my booking'
        $.each data.errors, (i, v) ->
          msg = '<label class="error" for="style_session_' + i + '">This field ' + v[0] + '</label>'
          $('input[name="style_session[' + i + ']"], select[name="style_session[' + i + ']').addClass('inputTxtError').after msg
          keys = Object.keys(data)
          $('input[name="style_session' + keys[0] + ']"]').focus()
      return
    error: ->
      # TODO: display a friendly disclaimer when the form is not sent
      submit_btn.val 'Confirm my booking'
      return

  ev.preventDefault()



