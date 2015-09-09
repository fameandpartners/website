window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @$container       = $(options.container)
    @$sideMenuTrigger = $(options.sideMenuTrigger)
    @$close           = $(options.close)
    @$arrowImg        = $(options.arrowImg)
    @$dropdownMenu    = $(options.dropdownMenu)
    @$overlay         = $(options.overlay || '#shadow-layer')

    @$sideMenuTrigger.on('click', @open)
    @$close.on('click', @close)
    @$overlay.on('click', @close)

    # $("a", "li", "ul", ".main-menu", @$container).on 'click', (e) =>
    $("a", @$container).on 'click', (e) =>
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

  blockScroll: =>
    sideMenuScrollTop = @$container.scrollTop()
    allDressesPosition = $(".all-dresses",@$container).position().top
    if sideMenuScrollTop > allDressesPosition - 50
      @$container.scrollTop(allDressesPosition - 50)

  slide: (e) =>
    $this = $(e.target)
    $thisDropdown = $this.siblings('.responsive-nav-dropdown')
    dropdownHeight = $thisDropdown.children('ul').outerHeight()
    $this.toggleClass('clicked')
    $thisDropdown.height( if $this.is('.clicked') then dropdownHeight else 0)

  open: () =>
    @$container.addClass('is-open')
    @$overlay.addClass('is-visible')

  close: () =>
    @$container.removeClass('is-open')
    @$overlay.removeClass('is-visible')
