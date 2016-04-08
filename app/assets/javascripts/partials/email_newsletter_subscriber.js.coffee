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
    $.getJSON(@url(), $this.serialize(), @handler)
    $.ajax
      url: $this.find('.js-en-field-mailchimp').value,
      method: 'GET',
      data: { email: $this.find('.js-en-field-email').value }

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
    message = 'Thanks for signing up. Use this promocode for $20 off your purchase: NEWS20.'
    window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 55555)
    $.cookie('email_newsletter', 'close', { expires: 365, path: '/' })
    window.track.event('Newsletter', 'Submitted', @campaign)
