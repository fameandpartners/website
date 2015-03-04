window.page or= {}

window.page.MobileMenu = class MobileMenu
  constructor: (opts = {}) ->              
    @opts = opts
    @$container = $(opts.container)
    @$container.find('a').on('click', @click)
  
  click: (e) =>
    vex.close()
    e.preventDefault()
    $el = $(e.currentTarget)
    $menu = $($el.data('menu-options-container'))
    @open($menu)
 

  open: ($menu) ->
    $('body').addClass('no-scroll') 
    vex.dialog.buttons.YES.text = 'X'    
    vex.dialog.alert
      message: $menu.html()
      className: "vex vex-theme-bottom-right-corner mobile-menu"     
      afterOpen: ->
        $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY
      afterClose: ->
        $('body').removeClass('no-scroll')  
