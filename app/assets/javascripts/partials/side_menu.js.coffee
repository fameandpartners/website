window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @$container       = $(options.container)
    @$sideMenuTrigger = $(options.sideMenuTrigger)
    @$close           = $(options.close)
    @$arrowImg        = $(options.arrowImg)
    @$dropdownMenu    = $(options.dropdownMenu)
    console.log @$close
    @$sideMenuTrigger.on('click', @open)
    @$close .on('click', @close)
    @$arrowImg.on 'click', (e) =>
      clicked = $(e.target).hasClass("clicked")
      @$arrowImg.removeClass("clicked")
      @$dropdownMenu.slideUp()
      if !clicked
        $(e.target).toggleClass("clicked")
        $('ul',e.target.closest('li')).slideDown(500)

  open: () =>
    @$container.animate({"margin-left": '+=300'}, 400);

  close: () =>
    console.log 'closeing'
    @$container.animate({"margin-left": '-=300'}, 400);
