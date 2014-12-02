window.helpers or= {}

window.helpers.addSendToBrideButton = (button) ->
  $button = $(button)

  # clear
  $button.off('click')
  $button.off('variant_selected')
  
  $(button).on('click', (e) ->
    e.preventDefault()
    button = $(e.currentTarget)

    if button.data('error')
      window.helpers.showErrors($(e.currentTarget).parent(), button.data('error'))
    else
      data = button.data('selected')
      data.id = button.data('id')

      $.ajax(
        url: button.attr('href'),
        method: 'PUT',
        dataType: 'json',
        data: data
        success: () ->
          console.log('success')
          #$(button).html('selected')
      )
  )
