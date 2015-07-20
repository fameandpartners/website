window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @$container       = $(options.container)
    @$sideMenuTrigger = $(options.sideMenuTrigger)
    @$close           = $(options.close)
    @$arrowImg        = $(options.arrowImg)
    @$dropdownMenu    = $(options.dropdownMenu)

    # I think this may fix the issue of iphone slideDown not working , need to test this
    $(document).bind 'mobileinit', ->
      # jQuery Mobile's Ajax navigation does not work in all cases (e.g.,
      # when navigating from a mobile to a non-mobile page), especially when going back, hence disabling it.
      $.extend $.mobile, ajaxEnabled: false

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
    @$container.css("margin-left","300px")

  close: () =>
    @$container.css("margin-left","-300px")
