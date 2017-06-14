window.page or= {}

window.page.EmailNewsletterSubscriber = class EmailNewsletterSubscriber
  constructor: (opts = {}) ->

    @campaign = opts.campaign || 'home'

    @$form = $('#' + opts.form)
    @$form.on('submit', @submit)

  url: =>
    @$form.attr('action') + "?callback=?"

  submit: (e) =>
    e.preventDefault()
    $this = $(e.target)
    url = $('.js-en-field-mailchimp', $this)[0].value
    email = $('.js-en-field-email', $this)[0].value
    $.ajax
      dataType: 'json'
      url: url
      async: true
      data: { email: email }
      success: @handler

  handler: (data) =>
    if (data.status == 'done')
      @success(data)
    else
      @failure(data)

  failure: =>
    title = 'Sorry'
    message = 'Please check if you entered a valid email address and try again.'
    window.helpers.showAlert(message: message, type: 'warning', title: title, timeout: 55555)
    window.track.event('Newsletter', 'Error')

  success: =>
    title = 'thanks babe'
    message = 'Thanks for signing up. Use this promocode for $25 off your purchase: NEWGIRL25.'
    window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 55555)
    $.cookie('email_newsletter', 'close', { expires: 365, path: '/' })
    window.track.event('Newsletter', 'Submitted')
