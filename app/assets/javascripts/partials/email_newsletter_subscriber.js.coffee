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
    $.getJSON(url, $this.serialize(), @handler)
    $.ajax
      url: url
      method: 'GET'
      data: { email: email }

  handler: (data) =>
    if (data.Status == 400)
      @failure(data)
    else
      @success(data)

  failure: (data) =>
    window.helpers.showAlert(message: data.Message, timeout:5555)
    window.track.event('Newsletter', 'Error', @campaign)

  success: =>
    title = 'thanks babe'
    message = 'Thanks for signing up. Use this promocode for $25 off your purchase: NEWGIRL25.'
    window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 55555)
    $.cookie('email_newsletter', 'close', { expires: 365, path: '/' })
    window.track.event('Newsletter', 'Submitted', @campaign)
