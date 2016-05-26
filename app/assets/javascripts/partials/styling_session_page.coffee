frm = $('#new_style_session')
frm_errors = $('label.error', frm)
submit_btn = $('.form-global .submit input', frm)
frm.submit (ev) ->
  ev.preventDefault()
  $.ajax
    type: 'post'
    url: frm.attr('action')
    data: frm.serialize()
    beforeSend: ->
      submit_btn.val 'Sending...'
      frm_errors.remove()
      return
    success: (data) ->
      if (data.success)
        $(".form-area .not-submitted").css("display", "none")
        $(".form-area .confirmation").css("display", "block")
      else
        submit_btn.val 'Confirm my booking'
        $.each data.errors, (attr_name, validation_msg) ->
          msg = '<label class="error" for="style_session_' + attr_name + '">This field ' + validation_msg[0] + '</label>'
          $('input[name="style_session[' + attr_name + ']"], select[name="style_session[' + attr_name + ']').after msg
          keys = Object.keys(data)
          $('input[name="style_session[' + keys[0] + ']"]').focus()
      return
    error: ->
      submit_btn.val 'Confirm my booking'
      msg = '<label class="error">Sorry, your request could not be sent.<br> Please try again later.</label>'
      submit_btn.after msg
      return
