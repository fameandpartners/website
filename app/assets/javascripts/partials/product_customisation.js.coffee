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
    # console.log("onClose")

  input: () =>
    @customisationTemplate(customizations: @opts.customizations)

  bind: () => 
    $('.customization-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    @selectedId = if id == @selectedId then null else id

    $el.toggleClass('active')    
    @$select.val(id)
  
    data = _.find(@opts.customizations, (o) => 
      o.id == @selectedId
    );
    @$action.html("#{data.name} +#{data.price}")

  open: () =>
    vex.defaultOptions.className = 'vex-theme-flat-attack';
    vex.dialog.open
      message:    @opts.message
      input:      @input
      afterOpen:  @bind 
      callback:   @onClose


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