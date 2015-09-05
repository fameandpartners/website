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

    $("a", "li", "ul", ".main-menu", @$container).on 'click', (e) =>
      @slide(e)

    $(@$container).on('mousedown touchstart', (e) =>
      if e.originalEvent.changedTouches?
        @xDown = e.originalEvent.changedTouches[0].screenX
    ).on 'mouseup touchend', (e2) =>
      if e2.originalEvent.changedTouches?
        @xUp = e2.originalEvent.changedTouches[0].screenX
        if @xDown > @xUp
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
    else if $("#lookbook-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#lookbook-menu .nav").height()
    else if $("#magazine-menu").css("margin-left") == "0px"
      lowestItemPosition = $("#magazine-menu .nav").height()

    if sideMenuScrollTop > lowestItemPosition - 200
      @$container.scrollTop(lowestItemPosition - 200)

  slide: (e) =>
    t = $(e.target)
    t = $('img',t) if $(t).is("a")

    clicked = t.hasClass("clicked")
    @$arrowImg.removeClass("clicked")
    @$dropdownMenu.css('height','0')

    if !clicked
      t.toggleClass("clicked")

      dropdown_li = $(t.closest('li'))
      clone = $('ul',dropdown_li).clone()
                    .css({'position':'absolute','visibility':'hidden','height':'auto'})
                    .addClass('slideClone')
                    .appendTo('body')
      newHeight = $(".slideClone").height()
      $(".slideClone").remove()
      $('ul',dropdown_li).css('height',newHeight + 'px')

  open: () =>
    @$container.css("margin-left", @$container.width())
    @$overlay.addClass('is-visible')
    $("#new-this-week-menu").show()
    $("#dresses-menu").show()
    $("#lookbook-menu").show()
    $("#magazine-menu").show()

  close: () =>
    $("#new-this-week-menu").hide().removeClass("sub-menu-slide-left")
    $("#dresses-menu").hide().removeClass("sub-menu-slide-left")
    $("#lookbook-menu").hide().removeClass("sub-menu-slide-left")
    $("#magazine-menu").hide().removeClass("sub-menu-slide-left")
    $("#inner-main-menu li[class*='normal-item']").removeClass('inner-main-menu-slide-left')
    $("#inner-main-menu li[class*='bottom-area']").removeClass('inner-main-menu-slide-left')
    @$container.css("margin-left", -@$container.width())
    @$overlay.removeClass('is-visible')

