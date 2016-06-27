function form_submit_ajax_validation(form_id, button_val, event_name, tracker_name) {

  var frm, email, submit_btn;

  frm = $(form_id);
  email = $('.js-en-field-email', frm);
  submit_btn = $('.submit input', frm);

  if (!tracker_name){
    tracker_name = form_id + 'FormSubmit';
  }

  frm.submit(function(ev) {
    ev.preventDefault();
    return $.ajax({
      type: 'post',
      url: frm.attr('action'),
      data: frm.serialize(),
      beforeSend: function() {
        submit_btn.val('Sending...');
        submit_btn.attr('disabled', true);
        $('label.error', frm).remove();
      },
      success: function(data) {
        if (data.success) {
          frm.closest(".js-en-not-submitted").css("display", "none");
          frm.closest(".js-en-not-submitted").next('.js-en-confirmation').css("display", "block");
          window.track.event(event_name +' Form', 'Submit', email.val());
          window.track.dataLayer.push({
            'event': tracker_name
          });
        } else {
          submit_btn.val(button_val);
          submit_btn.removeAttr("disabled");
          $.each(data.errors, function(attr_name, validation_msg) {
            var keys, msg;
            msg = '<label class="error" for="' + form_id + '_' + attr_name + '">This field ' + validation_msg[0] + '</label>';
            $('label[class="label-' + attr_name + '"]', frm).after(msg);
            keys = Object.keys(data);
            return $('input[name="' + form_id + '[' + keys[0] + ']"], select[name="' + form_id + '[' + keys[0] + ']"]', frm).focus()
          });
        }
      },
      error: function() {
        var msg;
        submit_btn.val(button_val);
        submit_btn.removeAttr("disabled");
        window.track.event(event_name +' Form', 'Error', email.val());
        msg = '<label class="error">Sorry, your request could not be sent.<br> Please try again later.</label>';
        submit_btn.after(msg);
      }
    });
  });

}
