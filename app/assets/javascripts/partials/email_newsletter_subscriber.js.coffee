window.page or= {}

window.page.EmailNewsletterSubscriber = class EmailNewsletterSubscriber
  constructor: (opts = {}) ->
    # $('#email-newsletter-signup').hide() if $.cookie('email_newsletter') == 'close'

    @campaign = opts.campaign || 'home'

    @$form = $(opts.form)
    @$form.on('submit', @submit)

    if window.current_site_version
      $('#fieldqulir').val(window.current_site_version.permalink)

  url: =>
    @$form.attr('action') + "?callback=?"

  submit: (e) =>
    e.preventDefault()
    $.getJSON(@url(), @$form.serialize(), @handler)

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
