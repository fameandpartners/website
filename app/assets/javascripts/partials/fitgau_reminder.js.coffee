window.page or= {}

window.page.FashionITGirlReminder = class FashionITGirlReminder
  constructor: (opts = {}) ->
    $form = $(opts.form)

    $form.submit( (e) ->
      e.preventDefault();

      url = $form.attr('action')
      data = $form.serialize()

      $.post(url, data, (data) ->
          title = "Thanks"
          message = 'Thanks for signing up. We will send you an email when entries open'
          window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 55555)
      )
      .fail(
          message = 'Sorry something went wrong'
          window.helpers.showAlert(message: message, timeout:5555)
        )
    );
