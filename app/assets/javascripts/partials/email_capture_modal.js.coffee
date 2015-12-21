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

    @promoStartedAt = $.cookie("auto_apply_promo_code_started_at")
    if @opts.timer
      # timer value is in hours
      if !@promoStartedAt
        today = +new Date()
        @promoStartedAt = today
        $.cookie("auto_apply_promo_code_started_at",@promoStartedAt)
    else
      today = +new Date()
      @promoStartedAt = today

    @checkState @opts.uuid, =>
      setTimeout(@open, timeout) if @pop

  checkState: (uuid, callback) =>
    if uuid
      $.get('/user_campaigns/check_state', {uuid: uuid}).success (response) =>
        if response.status == 'none'
          callback.call()
    else
      callback.call()
  pop: =>
    @opts.force || $.cookie(@cookie) != 'hide'

  afterClose: () ->
    $.cookie(@cookie, 'hide', { expires: 365, path: '/' })

  callback: (data) =>
    if data
      @process(data)
    else
      window.track.event('LandingPageModal', 'ClosedNoAction', @opts.promocode)

  process: (data) =>
    if !!data.email
      @opts.email = data.email
      $.post(@opts.action, data).done(@success).fail(@error)
    else
      setTimeout(@open, 250)
      window.helpers.showAlert(message: 'Did you mean to forget your email address?')

  success: (data) =>
    if data.status == 'ok'
      title = 'thanks babe'

      if @opts.uuid == 'auto_apply_promo' && @promoStartedAt
        @enableAutoApplyPromoCampaign()

      # show next popup in chain
      if @opts.promocode && @opts.promocode.toLowerCase().indexOf('birthdaybabe') > -1
        new window.page.PromocodeModal(promocode: @opts.promocode)
      else if @opts.uuid == 'bridesmaids_consultation_form'
        @registerBcfCampaign(@opts.email)
      else
        # show default system
        if @opts.promocode && @opts.uuid == 'auto_apply_promo'
          message = "Thanks babe. Your discount will be applied to your cart. Have fun x."
        else if @opts.promocode #&& @opts.uuid != 'auto_apply_promo'
          message = "Use this promocode for your next killer dress: #{@opts.promocode}."
        else
          message = "Thanks for joining!"
        if @opts.className != 'new-modal' && @opts.className != 'new-modal welcome-modal'
          window.helpers.showAlert(message: message, type: 'success', title: title, timeout: 999999)

      @fbPushTracking()
      window.track.event('LandingPageModal', 'Submitted', @opts.promocode)
      if @opts.className == 'new-modal' || @opts.className == 'new-modal welcome-modal' || @opts.className == 'classic-modal' || @opts.className == 'classic-modal welcome-modal'
        window.location.replace(window.location.href + "?pop_thanks=true")
        return
      window.location.reload()

  fbPushTracking: =>
    if @opts.fb
      window._fbq = window._fbq || []
      window._fbq.push(['track', @opts.fb, {'value':'0.00','currency':'USD'}]);

  failure: () =>
    window.helpers.showAlert(message: 'Is your email address correct?')
    window.track.event('LandingPageModal', 'Error', @opts.promocode)

  onOpen: (modal) =>
    $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY
    if @opts.submitText
      $('.vex-dialog-form button[type=submit]').val(@opts.submitText)

    window.track.event('LandingPageModal', 'Opened', @opts.promocode)

    if @opts.timer && @promoStartedAt
      $modal = $(modal)
      @countdownTimer = new window.page.CountdownTimer($modal, @promoStartedAt, @opts.timer)
      @countdownTimer.start()
      $.cookie('promo_heading', @opts.heading)
      $.cookie('promo_end_time', @opts.timer)

    if @opts.instagram_campaign?
      $('.vex-dialog-button-secondary').on 'click', =>
        @applyPromocode()
      $('.vex-overlay').on 'click', =>
        @applyPromocode()
        $(".vex-content .vex-dialog-buttons .vex-dialog-button-secondary").click()
    else
      $('.vex-overlay').on 'click', =>
        $(".vex-content .vex-dialog-buttons .vex-dialog-button-secondary").click()

  applyPromocode: () =>
    console.log 'we will apply promocode here by calling some controller and set session[:auto_apply_promo] = params[:auto_apply_promo].presence'

  message: =>
    h = if @opts.heading then "<h2>#{@opts.heading}</h2>" else ''
    str = "#{h}<p>#{@opts.message}</p>"

    if @opts.timer
      str += '<div class="timer-box"><span><span class="hh">48</span></span><span><span class="mm">00</span></span><span><span class="ss">00</span></span></div>'

    str

  registerBcfCampaign: (email) =>
    $.post('/user_campaigns', {
      promo_started_at: Math.floor(+new Date() / 1000),
      email:            email,
      uuid:             @opts.uuid,
      success: (result) =>
        vex.close()
    })

  enableAutoApplyPromoCampaign: () =>
    $.post('/user_campaigns', {
      promocode:        @opts.promocode,
      promo_started_at: Math.floor((@promoStartedAt / 1000)),
      duration:         @opts.timer,
      title:            @opts.heading,
      message:          @opts.message,
      uuid:             @opts.uuid,
      success: (result) =>
        new window.page.CountdownBanner(
          $('#countdown-banner'), @opts.heading, @opts.message, @promoStartedAt, @opts.timer
        )
    })

  onClose: () =>
    $.cookie("new-modal-close-state", "closed") if @opts.className == "new-modal"

  open: () =>
    window.track.event("LandingPageModal", "#{@opts.uuid} - #{@opts.promocode}")

    vex.dialog.buttons.NO.text = 'X'
    vex.dialog.open
      className: "vex vex-theme-flat-attack email-capture-modal #{@opts.className || ''}"
      input: @$container.html()
      message: @message()
      afterOpen: @onOpen
      afterClose: @onClose
      callback: @callback
      overlayClosesOnClick: @opts.instagram_campaign?

    if @opts.className == "new-modal add-to-cart"
      $(".add-to-cart .four-lipsticks img").click (e) ->
        $(".add-to-cart .four-lipsticks img").removeClass("selected")
        $(this).toggleClass("selected")

      checkoutBtn = $(".add-to-cart .checkout-btn")
      checkoutBtn.click (e) =>
        if checkoutBtn.hasClass("before-click") && $(".add-to-cart .four-lipsticks img.selected").length > 0
          checkoutBtn.removeClass("before-click").addClass("after-click")
          sku = $(".add-to-cart .four-lipsticks img.selected").data("sku")

          $.ajax(
            url: urlWithSitePrefix("/user_cart/products")
            type: "POST"
            dataType: "json"
            data: {gift_sku: sku}
          ).success(
            window.location.href = urlWithSitePrefix("/checkout")
          ).error( () =>
            window.helpers.showAlert(message: 'Error while add gift to cart ! ')
          )

window.page.PromocodeModal = class PromocodeModal extends EmailCaptureModal
  constructor: (opts = {}) ->
    vex.dialog.buttons.NO.text = 'X'
    promocode = opts.promocode || 'birthdaybabe'
    vex.dialog.open _.extend({
      promocode: promocode,
      message: '<h2 class="font-forum"><strong>ENJOY!</strong/> AND HAPPY BIRTHDAY FROM US.</h2>' +
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
  constructor: ($container, startTime, durationInHours, closeCallback , countDownType) ->
    @startTime     = startTime
    @duration      = durationInHours
    @closeCallback = closeCallback
    @countDownType = countDownType

    @$timerHours   = $container.find('.hh')
    @$timerMinutes = $container.find('.mm')
    @$timerSeconds = $container.find('.ss')

    @updateTimer(@startTime, @duration)

  formatTime: (time) ->
    if time < 10
      "0#{time}"
    else
      "#{time}"

  updateSaleBannerClock: ->
    $("#sale-banner .heading").text("Second chance! "+ $("#sale-banner .heading").text())
    if @countDownType == 'modal'
      $.cookie("auto_apply_promo_code_started_at", +new Date())
      $.cookie('promo_end_time', 12)
      @startTime = $.cookie("auto_apply_promo_code_started_at")
      @duration  = $.cookie('promo_end_time')
      @countDownType = 'ending'
      @start()
    else if @countDownType == 'faadc'
      $.cookie("auto_apply_coupon_start_time", +new Date())
      $.cookie('auto_apply_coupon_duration',12)
      @startTime = $.cookie("auto_apply_coupon_start_time")
      @duration  = $.cookie('auto_apply_coupon_duration')
      @countDownType = 'ending'
      @start()
    else if @countDownType == 'ending'
      $.removeCookie("auto_apply_promo_code_started_at")
      $.removeCookie('promo_end_time')
      $.removeCookie("auto_apply_coupon_start_time")
      $.removeCookie('auto_apply_coupon_duration')
      $("#sale-banner .clock").hide()

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
     @updateSaleBannerClock()
     false

  start: () ->
    setTimeout =>
      if @updateTimer(@startTime, @duration)
        @start()
      else if @closeCallback
        @closeCallback()
    , 1000
