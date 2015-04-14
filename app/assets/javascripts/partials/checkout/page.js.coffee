window.checkout ||= {}

window.checkout.page ||= {
  ajax_callbacks: {},

  onAjaxLoadingHandler: (e) ->
    checkout.page.callAjaxCallbacks('loading')

    # shipping address buttons
    $form = $(e.currentTarget).closest('form')[0]
    if $form && _.isFunction($form.checkValidity) && !$form.checkValidity()
      # submit form in order to show validation messages
      # without messages updates & etc
      return true

    $button = $(e.currentTarget)
    if $button.is('input')
      previous_message = $button.val()
    else if $button.is('button')
      previous_message = $button.text()

    loading_message = $button.data('loading') || 'Updating...'

    if $button.is('input')
      $button.val(loading_message)
    else if $button.is('button')
      $button.text(loading_message)

    $button.addClass('updating')
    # disable button only after form submitting! Otherwise, the form will not be sent!
    setTimeout(
      () ->
        $button.attr('disabled', true)
      , 100
    )

    checkout.page.addAjaxCallback('all', () ->
      $button.removeAttr('disabled').removeClass('updating')

      if $button.is('input')
        $button.val(previous_message)
      else if $button.is('button')
        $button.text(previous_message)
    )

  addAjaxCallback: (state, callback) ->
    checkout.page.ajax_callbacks[state] or= []
    if !_.contains(checkout.page.ajax_callbacks[state], callback)
      checkout.page.ajax_callbacks[state].push(callback)
    return true

  callAjaxCallbacks: () ->
    _.each(arguments, (state) ->
      callbacks = checkout.page.ajax_callbacks[state] || []
      _.each(callbacks, (callback) ->
        callback.call()
      )
    )
    return true

  onAjaxSuccessHandler: (e) ->
    checkout.page.refreshFormView()
    checkout.page.callAjaxCallbacks('success', 'all')

  onAjaxFailureHandler: (e) ->
    checkout.page.refreshFormView()
    scrollScreenTo($("#errorExplanation"))
    checkout.page.callAjaxCallbacks('failure', 'all')

}
