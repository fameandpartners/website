frm = $('#new_wedding_consultation')
submit_btn = $('.submit input', frm)
email = $('.js-en-field-email', frm)
frm.submit (ev) ->
  ev.preventDefault()
  $.ajax
    type: 'post'
    url: frm.attr('action')
    data: frm.serialize()
    beforeSend: ->
      submit_btn.val 'Sending...'
      submit_btn.attr('disabled', true)
      $('label.error', frm).remove()
      return
    success: (data) ->
      if (data.success)
        $(".form-area .js-en-not-submitted").css("display", "none")
        $(".form-area .js-en-confirmation").css("display", "block")
        window.track.event('Wedding Styling Session Form', 'Submit', email.val())
        window.track.dataLayer.push({ 'event': 'weddingStylingFormSubmit' })
      else
        submit_btn.val 'Confirm my booking'
        submit_btn.removeAttr("disabled")
        $.each data.errors, (attr_name, validation_msg) ->
          msg = '<label class="error" for="wedding_consultation_' + attr_name + '">This field ' + validation_msg[0] + '</label>'
          $('label[class="label-' + attr_name + '"]').after msg
          keys = Object.keys(data)
          $('input[name="wedding_consultation[' + keys[0] + ']"], select[name="wedding_consultation[' + keys[0] + ']"]').focus()
      return
    error: ->
      submit_btn.val 'Confirm my booking'
      submit_btn.removeAttr("disabled")
      window.track.event('Wedding Styling Session Form', 'Error', email.val())
      msg = '<label class="error">Sorry, your request could not be sent.<br> Please try again later.</label>'
      submit_btn.after msg
      return
