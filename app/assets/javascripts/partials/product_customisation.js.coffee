#= require 'templates/product_customisation'

window.page or= {}
window.ProductCustomisation = class ProductCustomisation
  
  @selectedId: null 
  customisationTemplate: JST['templates/product_customisation']

  constructor: (opts = {}) ->        
    @opts = opts
    @$action = $('#product-customizations-action')
    @$action.on('click', @open)
    @$select = $('#product-customizations')
    
  onClose: (data) =>

  input: () =>
    @customisationTemplate(customizations: @opts.customizations)

  bind: () => 
    $('.customization-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    
    if id == 'original'
      @$action.html("Customize")
      @$select.val("")
    else 
      $el.toggleClass('active')    
      @$select.val(id)
      data = _.find(@opts.customizations, (o) => 
        o.id == id
      );      
      @$action.html("#{data.name} +#{data.price}") if data

    setTimeout(vex.close, 30)
    

  open: () =>
    vex.defaultOptions.className = 'vex-theme-flat-attack';
    vex.dialog.open
      message:    @opts.message
      input:      @input
      afterOpen:  @bind 
      callback:   @onClose
      className: 'vex vex-theme-flat-attack product-customizations'


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