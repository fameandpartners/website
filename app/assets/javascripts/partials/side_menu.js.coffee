window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @$container       = $(options.container)
    @$sideMenuTrigger = $(options.sideMenuTrigger)
    @$close           = $(options.close)
    @$arrowImg        = $(options.arrowImg)
    @$dropdownMenu    = $(options.dropdownMenu)

    @$sideMenuTrigger.on('click', @open)
    @$close .on('click', @close)
    @$arrowImg.on 'click', (e) =>
      t = $(e.target)
      clicked = t.hasClass("clicked")
      @$arrowImg.removeClass("clicked")
      @$dropdownMenu.css('height','0')

      if !clicked
        t.toggleClass("clicked")

        clone = $('ul',t.closest('li')).clone()
                      .css({'position':'absolute','visibility':'hidden','height':'auto'})
                      .addClass('slideClone')
                      .appendTo('body')
        newHeight = $(".slideClone").height()
        $(".slideClone").remove()
        dropdown_li = $(t.closest('li'))
        $('ul',dropdown_li).css('height',newHeight + 'px')

  open: () =>
    @$container.css("margin-left","300px")

  close: () =>
    @$container.css("margin-left","-300px")
