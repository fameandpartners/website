window.SideMenu = class SideMenu

  constructor: (options = {}) ->
    @rendered   = false
    @$container = $('#sideMenu')

    _.bindAll(@, 'open', 'close')

    $('#side-menu-trigger').on('click', @open)
    $('#close').on('click', @close)
    $('.arrow img').on 'click', ->
      $(this).toggleClass("clicked")

  open: () ->
    $("#sideMenu").animate({"margin-left": '+=300'}, 400);

  close: () ->
    $("#sideMenu").animate({"margin-left": '-=300'}, 400);

