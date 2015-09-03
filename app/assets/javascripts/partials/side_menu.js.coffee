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

  slideMainMenu: =>
    $("#inner-main-menu li[class*='normal-item']").toggleClass('inner-main-menu-slide-left')

  blockScroll: =>
    sideMenuScrollTop = @$container.scrollTop()
    allDressesPosition = $("#contact-us",@$container).position().top
    if sideMenuScrollTop > allDressesPosition - 50
      @$container.scrollTop(allDressesPosition - 50)

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

  close: () =>
    @$container.css("margin-left", -@$container.width())
    @$overlay.removeClass('is-visible')
