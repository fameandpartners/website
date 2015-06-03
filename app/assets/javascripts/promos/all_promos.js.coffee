window.initPromos = ->
  init48h15PercentOffPromo = ->
    allowedPathNames = ['/', '/dresses']

    # enable this promo popup only for landing page and dresses page
    if allowedPathNames.indexOf(window.location.pathname) == -1
      return

    promoEndsAt = $.cookie('promo_48h_15_percent_off_ends_at')

    return if !promoEndsAt || !promoEndsAt.length

    endDate = Date.parse(promoEndsAt)

    return if endDate < new Date()

    vex.open({
      content: '<div id="promo_48h_15_percent_off"><div class="h1">48h only! Save 15% off your killer prom dress</div><div class="h1 timer-box"><span class="hh">48</span><span class="mm">00</span><span class="ss">00</span></div></div>',
      className: 'vex-dialog-default vex-dialog-bottom vex-dialog-pink'
    })

    $promoBanner = $('#promo_48h_15_percent_off')
    $hours       = $promoBanner.find('.hh')
    $minutes     = $promoBanner.find('.mm')
    $seconds     = $promoBanner.find('.ss')

    endDateInMs = +endDate

    formatTime = (time) ->
      if time < 10
        "0#{time}"
      else
        "#{time}"

    updateTimer = ->
      console.log('update timer')
      currentTime = +new Date()
      diffInSeconds = Math.floor((endDateInMs - currentTime) / 1000)
      if diffInSeconds > 0
        hours   = Math.floor(diffInSeconds / 3600)
        minutes = Math.floor((diffInSeconds - hours * 3600) / 60)
        seconds = Math.floor(diffInSeconds - hours * 3600 - minutes * 60)

        $hours.html(formatTime(hours))
        $minutes.html(formatTime(minutes))
        $seconds.html(formatTime(seconds))

        initTimer()

    initTimer = ->
      setTimeout ->
        updateTimer()
      , 1000

    initTimer()

  init48h15PercentOffPromo()
