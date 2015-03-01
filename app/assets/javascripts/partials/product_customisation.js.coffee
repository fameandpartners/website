#= require 'templates/product_customisation'

window.page or= {}
window.ProductCustomisation = class ProductCustomisation
  
  template: JST['templates/product_customisation']

  constructor: (opts = {}) ->        
    @opts = opts
    @$action = $('#product-customizations-action').on('click', @open)
    @$container = $('#product-customizations-content')
    @$select = $('#product-customizations')
    @$overlay = $('#product-overlay').on('click', @close)
    
  close: (data) =>
    @$container.removeClass('speed-in')
    @$overlay.removeClass('is-visible')
    $('body').removeClass('no-scroll')

  bind: () => 
    selectedId = @$select.val()
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
      name = $el.data('name')
      price = $el.data('price')
      @$action.html("#{name} +#{price}")

    setTimeout(@close, 50)
    

  open: () =>  
    @$container.addClass('speed-in') 
    @$overlay.addClass('is-visible')
    
    @bind()


    # vex.defaultOptions.className = 'vex-theme-flat-attack';
    # vex.dialog.open
    #   message:    @opts.message
    #   input:      @input
    #   afterOpen:  @bind 
    #   callback:   @onClose
    #   className: 'vex vex-theme-flat-attack product-customizations side-panel'


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