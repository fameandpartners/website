#= require 'templates/product_customisation'

window.page or= {}
window.ProductCustomisation = class ProductCustomisation
  
  template: JST['templates/product_customisation']

  constructor: (opts = {}) ->        
    @opts = opts
    @$action = $('#product-customizations-action')
    @$action.on('click', @open)
    @$select = $('#product-customizations')
    
  onClose: (data) =>
    $('.vex-content').addClass('no-scroll')
    $('body').removeClass('no-scroll')

  input: () =>
    @template(customizations: @opts.customizations)

  bind: () => 
    selectedId = @$select.val()
    console.log selectedId 
    if selectedId 
      $(".customization-option[data-id='#{selectedId}']").toggleClass('active')
    else
      $(".customization-option[data-id='original']").toggleClass('active')

    $('.customization-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    $('.active').removeClass('active')    
    $el.toggleClass('active')   

    if id == 'original'
      @$action.html("Customize")
      @$select.find('option:selected').removeAttr('selected');
    else       
      @$select.val(id)
      data = _.find(@opts.customizations, (o) => 
        o.id == id
      );      
      @$action.html("#{data.name} +#{data.price}") if data

    setTimeout(vex.close, 30)
    

  open: () =>
    $('body').addClass('no-scroll')
    vex.defaultOptions.className = 'vex-theme-flat-attack';
    vex.dialog.open
      message:    @opts.message
      input:      @input
      afterOpen:  @bind 
      callback:   @onClose
      className: 'vex vex-theme-flat-attack product-customizations side-panel'


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