window.page or= {}

window.page.EmailCaptureModal = class EmailCaptureModal
  # @opts[Object]
  #   action    - submit url
  #   className - additional classname for container
  #   container - ID of html container that should be used as content for modal
  #   content   - DOM element containing content to be displayed in modal
  #   force     - force showing modal
  #   heading   - heading text
  #   promocode - promo code
  #   timeout   - timeout to show modal
  #   timer     - countdown timer value in hours (ex. 48h)
  #   uuid      - campaign uuid (optional parameter)
  constructor: (opts = {}) ->
    @opts = opts
    if ('timeout' of opts) # this allow us to set 0 as value
      timeout = opts.timeout * 1000
    else
      timeout = 3000
    @$container = $(opts.container)
    @cookie = "email_capture_#{@opts.content}"

    if @opts.timer
      # timer value is in hours
      @promoStartedAt = $.cookie("auto_apply_promo_code_started_at")
      if !@promoStartedAt
        today = +new Date()
        @promoStartedAt = today
      else
        @promoStartedAt = +@promoStartedAt * 1000

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
    @enableAutoApply()

    if data.status == 'ok'
      title = 'thanks babe'

      # show next popup in chain
      if @opts.promocode && @opts.promocode.toLowerCase() == 'birthdaybabe'
        new window.page.PromocodeModal(promocode: @opts.promocode)
      else if @opts.uuid == 'auto_apply_promo' && @promoStartedAt
        new window.page.CountdownBanner($('#countdown-banner'), @opts.heading, @opts.message, @promoStartedAt, @opts.timer)
      else
        # show default system
        if @opts.promocode && @opts.uuid != 'auto_apply_promo'
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
    $.post('/user_campaigns', {
      promocode:        @opts.promocode,
      promo_started_at: (@promoStartedAt / 1000),
      duration:         @opts.timer,
      title:            @opts.heading,
      message:          @opts.message,
      uuid:             @opts.uuid
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
    vex.dialog.buttons.NO.text = 'X'
    promocode = opts.promocode || 'birthdaybabe'
    vex.dialog.open _.extend({
      promocode: promocode,
      message: '<h2 class="font-forum"><strong>Thanks babe!</strong/> enjoy 15% off <br> your entire order now.</h2>' +
        "<div class=\"pink-light single\">Use code #{ promocode } @ checkout</div>",
      className: 'vex vex-theme-flat-attack email-capture-modal vex-dialog-bottom vex-dialog-pink vex-text',
      popup: true,
      afterOpen: @updateHtml,
      timeout: 0
    }, opts)

  updateHtml: (modal) ->
    modal.find('.vex-dialog-buttons button').addClass('btn btn-black')

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

window.page.showCountdownTimer = (title, message, promoStartedAt, durationInHours) ->
  new window.page.CountdownBanner($('#countdown-banner'), title, message, promoStartedAt, durationInHours)

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


window.page.showTellMomModal = ->
  vex.dialog.buttons.NO.text = 'X'

  updateHtml = (modal) ->
    modal.find('.vex-dialog-buttons button').addClass('btn btn-black')
    $form = modal.find('form')
    $email = $form.find('input[name=email]')

    $form.on 'submit', (e) ->
      $.post('/user_campaigns/tell_mom', {email: $email.val()}).done ->
        vex.close()
      e.preventDefault()
      e.stopPropagation()
      false


  vex.dialog.open
    message: '<h2>Nice picks! How would mom say no?</h2><p>SEND HER YOUR SELECTION NOW:</p>',
    className: 'vex-dialog-bottom vex-dialog-pink vex-text vex-dialog-pink-reverse',
    popup: true,
    input: $('#tell-mom-popup-content-template').html()
    timeout: 0,
    afterOpen: updateHtml
