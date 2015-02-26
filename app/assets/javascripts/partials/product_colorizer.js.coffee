#= require 'templates/product_colors'

window.page or= {}
window.ProductColorizer = class ProductColorizer
  
  @selectedId: null 
  template: JST['templates/product_colors']

  constructor: (opts = {}) ->        
    @opts = opts
    @$action = $(opts.action)
    @$select = $(opts.select)
    @$action.on('click', @open)
    @allColors = @opts.colors.concat(@opts.colors)
    
  input: () =>
    @template(colors: @opts.colors, customColors: @opts.colors)

  bind: () => 
    selectedId = @$select.val()
    if selectedId 
      $(".color-option[data-id='#{selectedId}']").toggleClass('active')
      
    $('.color-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    $('.active').removeClass('active')    
    $el.toggleClass('active')    
    @$select.val(id)
    data = _.find(@allColors, (o) => 
      o.id == id
    );      

    if data.price
      @$action.html("#{data.display} +#{data.price}")
    else
      @$action.html(data.display)

    setTimeout(vex.close, 30)
    
  open: () =>
    vex.defaultOptions.className = 'vex-theme-flat-attack';
    vex.dialog.open
      input:      @input
      afterOpen:  @bind 
      callback:   @onClose
      className: 'vex vex-theme-flat-attack product-colorization side-panel'


  # defaultOptions:
  #   content: ''
  #   showCloseButton: true
  #   escapeButtonCloses: true
  #   overlayClosesOnClick: true
  #   appendLocation: 'body'
  #   className: ''
  #   css: {}
  #   overlayClassName: ''
  #   overlayCSS: {}
  #   contentClassName: ''
  #   contentCSS: {}
  #   closeClassName: ''
  #   closeCSS: {}          