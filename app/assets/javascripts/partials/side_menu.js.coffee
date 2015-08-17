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
      @xDown = e.originalEvent.changedTouches[0].screenX
    ).on 'mouseup touchend', (e2) =>
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
