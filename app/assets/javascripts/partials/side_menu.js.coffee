window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @$container       = $(options.container)
    @$sideMenuTrigger = $(options.sideMenuTrigger)
    @$close           = $(options.close)
    @$arrowImg        = $(options.arrowImg)
    @$dropdownMenu    = $(options.dropdownMenu)
    @$overlay         = $(options.overlay || '#shadow-layer')

    @$sideMenuTrigger.on('click', @open)
    @$close .on('click', @close)

    $(@$overlay).on 'click', =>
      @close()

    $(window).delay(250).on 'resize', =>
      if($('#sideMenu nav').is(':hidden'))
        @close()

    $(document).on('mousedown', (e) =>
      @xDown = e.originalEvent.x
      @blockScroll()

    ).on 'mouseup', (e2) =>
      @xUp = e2.originalEvent.x
      if @xDown > @xUp + 70
        @close()
      @blockScroll()

    $(document).on('touchstart', (e) =>
      @xDown = e.originalEvent.changedTouches?[0].clientX
      @blockScroll()

    ).on 'touchend', (e2) =>
      @xUp = e2.originalEvent.changedTouches?[0].clientX
      if @xDown > @xUp + 70
        @close()
      @blockScroll()

    $('#sideMenu').on 'mousewheel', (e) =>
      @blockScroll()

    $("#new-this-week-open").on 'click', =>
      @slideMainMenu()
      $("#new-this-week-menu").toggleClass("sub-menu-slide-left")
    $("#new-this-week-menu .arrow").on 'click', =>
      $("#new-this-week-menu").toggleClass("sub-menu-slide-left")
      @slideMainMenu()

    $("#dress-menu-open").on 'click', =>
      @slideMainMenu()
      $("#dresses-menu").toggleClass("sub-menu-slide-left")
    $("#dresses-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#dresses-menu").toggleClass("sub-menu-slide-left")

    $("#culture-menu-open").on 'click', =>
      @slideMainMenu()
      $("#culture-menu").toggleClass("sub-menu-slide-left")
    $("#culture-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#culture-menu").toggleClass("sub-menu-slide-left")

    $("#event-menu-open").on 'click', =>
      @slideMainMenu()
      $("#events-menu").toggleClass("sub-menu-slide-left")
    $("#events-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#events-menu").toggleClass("sub-menu-slide-left")

    $("#wedding-menu-open").on 'click', =>
      @slideMainMenu()
      $("#wedding-menu").toggleClass("sub-menu-slide-left")
    $("#wedding-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#wedding-menu").toggleClass("sub-menu-slide-left")

    $("#lookbook-menu-open").on 'click', =>
      @slideMainMenu()
      $("#lookbook-menu").toggleClass("sub-menu-slide-left")
    $("#lookbook-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#lookbook-menu").toggleClass("sub-menu-slide-left")

    $("#magazine-menu-open").on 'click', =>
      @slideMainMenu()
      $("#magazine-menu").toggleClass("sub-menu-slide-left")
    $("#magazine-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#magazine-menu").toggleClass("sub-menu-slide-left")

    $("#moodboards-menu-open").on 'click', =>
      item_num = $("#moodboards-menu .normal-item").size()
      if item_num < 3
        window.location.href = urlWithSitePrefix("/wishlist")
      else
        @slideMainMenu()
        $("#moodboards-menu").toggleClass("sub-menu-slide-left")
    $("#moodboards-menu .arrow").on 'click', =>
      @slideMainMenu()
      $("#moodboards-menu").toggleClass("sub-menu-slide-left")

  slideMainMenu: =>
    $("#inner-main-menu li[class*='normal-item']").toggleClass('inner-main-menu-slide-left')
    $("#inner-main-menu li[class*='bottom-area']").toggleClass('inner-main-menu-slide-left')

  blockScroll: =>
    sideMenuScrollTop = @$container.scrollTop()
    if $("#inner-main-menu .normal-item:first").css("margin-left") == "20px"
      lowestItemPosition = $("#inner-main-menu").height()
    else if $("#new-this-week-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#new-this-week-menu .nav").height()
    else if $("#dresses-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#dresses-menu .nav").height() - 150
    else if $("#events-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#events-menu .nav").height()
    else if $("#lookbook-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#lookbook-menu .nav").height()
    else if $("#culture-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#lookbook-menu .nav").height()
    else if $("#magazine-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#magazine-menu .nav").height()

    if sideMenuScrollTop > lowestItemPosition - 200
      @$container.scrollTop(lowestItemPosition - 200)

  open: () =>
    @$container.css("margin-left", @$container.width())
    @$overlay.addClass('is-visible')
    $("#new-this-week-menu").show()
    $("#dresses-menu").show()
    $("#culture-menu").show()
    $("#events-menu").show()
    $("#lookbook-menu").show()
    $("#magazine-menu").show()

  close: () =>
    $("#new-this-week-menu").hide().removeClass("sub-menu-slide-left")
    $("#dresses-menu").hide().removeClass("sub-menu-slide-left")
    $("#culture-menu").hide().removeClass("sub-menu-slide-left")
    $("#events-menu").hide().removeClass("sub-menu-slide-left")
    $("#lookbook-menu").hide().removeClass("sub-menu-slide-left")
    $("#magazine-menu").hide().removeClass("sub-menu-slide-left")
    $("#inner-main-menu li[class*='normal-item']").removeClass('inner-main-menu-slide-left')
    $("#inner-main-menu li[class*='bottom-area']").removeClass('inner-main-menu-slide-left')
    @$container.css("margin-left", -@$container.width())
    @$overlay.removeClass('is-visible')

