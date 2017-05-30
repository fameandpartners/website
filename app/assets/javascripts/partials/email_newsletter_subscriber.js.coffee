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
    url = $('input[name="url"]', $this)[0].value
    email = $('input[name="email"]', $this)[0].value
    service = $('input[name="service"]', $this)[0].value
    $.ajax
      dataType: 'json'
      url: url
      async: true
      data: { email: email, service: service }
      success: @handler
      method: 'POST'

  handler: (data) =>
    if (data.status == 'done')
      @success(data)
    else
      @failure(data)

  failure: =>
    title = 'Sorry'
    message = 'Please check if you entered a valid email address and try again.'
    window.helpers.showAlert(message: message, type: 'warning', title: title, timeout: 55555)
    window.track.event('Newsletter', 'Error', @campaign)

  success: =>
    title = 'thanks babe'
    message = 'Thanks for signing up. Use this promocode for $25 off your purchase: NEWGIRL25.'
    window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 55555)
    $.cookie('email_newsletter', 'close', { expires: 365, path: '/' })
    window.track.event('Newsletter', 'Submitted', @campaign)
