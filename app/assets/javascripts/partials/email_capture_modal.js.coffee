window.page or= {}

window.page.EmailCaptureModal = class EmailCaptureModal
  # @opts[Object]
  #   action - submit url
  #   className - additional classname for container
  #   container - markup container
  #   content: - DOM element containing content to be displayed in modal
  #   force: force showing modal
  #   heading - heading text
  #   promocode - promo code
  #   timeout - timeout to show modal
  #   timer - countdown timer value in hours (ex. 48h)
  #   auto_apply_promo - automatically apply promo code for cart
  constructor: (opts = {}) ->
    @opts = opts
    if ('timeout' of opts) # this allow us to set 0 as value
      timeout = opts.timeout * 1000
    else
      timeout = 3000
    @$container = $(opts.container)
    @cookie = "email_capture_#{@opts.content}"

    promo_cookie = "promos_#{@opts.promocode}_started_at"

    if @opts.timer
      # timer value is in hours
      @promoStartedAt = $.cookie(promo_cookie)
      if !@promoStartedAt
        today = +new Date()
        $.cookie(promo_cookie, today, {expires: Math.floor(@opts.timer / 24) + 1})
        @promoStartedAt = today
      else
        @promoStartedAt = +@promoStartedAt

    setTimeout(@open, timeout) if @pop

  pop: =>
    @opts.force || $.cookie(@cookie) != 'hide'

  afterClose: () ->
    $.cookie(@cookie, 'hide', { expires: 365, path: '/' })

  callback: (data) =>
    if data
      @process(data)
    else
      window.track.event('LandingPageModal', 'ClosedNoAction', @opts.content, @opts.promocode)

  process: (data) =>
    if !!data.email
      $.post(@opts.action, data).done(@success).fail(@error)
    else
      setTimeout(@open, 250)
      window.helpers.showAlert(message: 'Did you mean to forget your email address?')

  success: (data) =>
    if @opts.auto_apply_promo && @promoStartedAt
      @enableAutoApply()

    if data.status == 'ok'
      title = 'thanks babe'

      # show next popup in chain
      if @opts.promocode && @opts.promocode.toLowerCase() == 'birthdaybabe'
        new window.page.PromocodeModal(promocode: @opts.promocode)
      else if @opts.auto_apply_promo && @promoStartedAt
        new window.page.CountdownBanner($('#countdown-banner'), @opts.heading, @opts.message, @promoStartedAt, @opts.timer)
      else
        # show default system
        if @opts.promocode && !@opts.auto_apply_promo
          message = "Use this promocode for your next killer dress: #{@opts.promocode}."
        else
          message = "Thanks for joining!"
        window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 999999)

      window.track.event('LandingPageModal', 'Submitted',  @opts.content, @opts.promocode)

  failure: () =>
    window.helpers.showAlert(message: 'Is your email address correct?')
    window.track.event('LandingPageModal', 'Error', @opts.content, @opts.promocode)

  onOpen: (modal) =>
    $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY
    if @opts.submitText
      $('.vex-dialog-form button[type=submit]').val(@opts.submitText)

    window.track.event('LandingPageModal', 'Opened', @opts.content, @opts.promocode)

    if @opts.timer && @promoStartedAt
      $modal = $(modal)
      @countdownTimer = new window.page.CountdownTimer($modal, @promoStartedAt, @opts.timer)
      @countdownTimer.start()

  message: =>
    h = if @opts.heading then "<h2>#{@opts.heading}</h2>" else ''
    str = "#{h}<p>#{@opts.message}</p>"

    if @opts.timer
      str += '<div class="timer-box"><span><span class="hh">48</span></span><span><span class="mm">00</span></span><span><span class="ss">00</span></span></div>'

    str

  enableAutoApply: () =>
    $.post('/promos/enable_auto_apply', {
      promocode:        @opts.promocode,
      promo_started_at: @promoStartedAt,
      duration:         @opts.timer
    })

  open: () =>
    vex.dialog.buttons.NO.text = 'X'
    vex.dialog.open
      className: "vex vex-theme-flat-attack email-capture-modal #{@opts.className || ''}"
      input: @$container.html()
      message: @message()
      afterOpen: @onOpen
      afterClose: @onClose
      callback: @callback

window.page.PromocodeModal = class PromocodeModal extends EmailCaptureModal
  constructor: (opts = {}) ->
    opts = _.extend({
      promocode: 'birthdaybabe',
      heading: '<h3><strong>Thanks babe,</strong/> enjoy 15% off <br> your entire order now</h3>',
      message: "<h3>use code birthdaybabe @ checkout</h3>",
      className: 'vex-dialog-bottom vex-dialog-pink vex-text',
      popup: true,
      timeout: 0
    }, opts)
    super(opts)

window.page.CountdownBanner = class CountdownBanner
  constructor: ($container, title, message, startTime, durationInHours) ->
    @$container     = $container
    @title          = title
    @message        = message
    @countdownTimer = new window.page.CountdownTimer($container, startTime, durationInHours, => @hide())

    @show(title, message)
    @countdownTimer.start()

    @initCallbacks()

  initCallbacks: ->
    @$container.find('a.close').on 'click', =>
      @hide()
      false

  show: (title, message) ->
    if title
      @$container.find('.banner-title').html(title)

    if message
      @$container.find('.banner-message').html(message)
    @$container.removeClass('hidden')

  hide: ->
    @$container.addClass('hidden')

window.page.CountdownTimer = class CountdownTimer
  constructor: ($container, startTime, durationInHours, closeCallback) ->
    @startTime     = startTime
    @duration      = durationInHours
    @closeCallback = closeCallback

    @$timerHours   = $container.find('.hh')
    @$timerMinutes = $container.find('.mm')
    @$timerSeconds = $container.find('.ss')

    @updateTimer(@startTime, @duration)

  formatTime: (time) ->
    if time < 10
      "0#{time}"
    else
      "#{time}"

  updateTimer: (startTime, durationInHours) ->
    currentTime = +new Date()
    diffInSeconds = Math.floor((currentTime - startTime) / 1000)
    diffInSeconds = durationInHours * 3600 - diffInSeconds

    if diffInSeconds > 0
      hours   = Math.floor(diffInSeconds / 3600)
      minutes = Math.floor((diffInSeconds - hours * 3600) / 60)
      seconds = Math.floor(diffInSeconds - hours * 3600 - minutes * 60)

      @$timerHours.html(@formatTime(hours))
      @$timerMinutes.html(@formatTime(minutes))
      @$timerSeconds.html(@formatTime(seconds))
      true
    else
     false

  start: () ->
    setTimeout =>
      if @updateTimer(@startTime, @duration)
        @start()
      else if @closeCallback
        @closeCallback()
    , 1000

