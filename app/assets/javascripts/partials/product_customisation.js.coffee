window.page or= {}

window.page.BaseProductCustomizer = class BaseProductCustomizer
  constructor: (opts = {}) ->        
    @opts = opts

    @$container = $(opts.container)
    @selector = new window.helpers.ProductSideSelectorPanel(@$container)
    @$action = $(opts.action).on('click', @selector.open)    
    @$select = $(opts.select)    

  close: ()=> 
    setTimeout(@selector.close, 50)

window.page.ProductSizer = class ProductSizer extends BaseProductCustomizer
  constructor: (opts = {}) ->        
    super(opts)
    @$container.find('.product-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    name = $el.data('name')
    price = $el.data('price')

    $(@$container).find('.active').removeClass('active')    
    $el.toggleClass('active')    
    @$select.val(id)

    if price
      @$currentPrice.data('size-price', price)
      @$action.html("#{name} +#{price}")
    else
      @$currentPrice.data('size-price', 0)
      @$action.html(name)

    @close(price)
    
window.page.ProductColorizer = class ProductColorizer extends BaseProductCustomizer
  
  constructor: (opts = {}, slider) ->        
    super(opts)  
    @$container.find('.color-option').on('click', @toggle)
    @slider = slider
    if opts.color_id
      @$container.find("[data-id=#{opts.color_id}]").click()

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    name = $el.data('name')
    price = $el.data('price')

    $(@$container).find('.active').removeClass('active')    
    $el.toggleClass('active')    
    @$select.val(id)
    @slider.showImagesWithColor(id)

    if price
      @$action.html("#{name} +#{price}")
      @message = "You have selected a custom color, so we don't have a pic of this dress yet"
    else
      @$action.html(name)

    @close(price)    
    setTimeout(@customColorAlert, 60)

  customColorAlert: () =>
    window.helpers.showAlert(message: @message) if @message 


window.page.ProductCustomisation = class ProductCustomisation extends BaseProductCustomizer
  
  constructor: (opts = {}) ->        
    super(opts)

    @$container.find('.customization-option').on('click', @toggle)
    
  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    $(@$container).find('.active').removeClass('active')    
    $el.toggleClass('active')   

    if id == 'original'
      @$action.html("Customize")
      @$select.find('option:selected').removeAttr('selected');
      @$currentPrice.data('customization-price', 0)
    else       
      @$select.val(id)
      name = $el.data('name')
      price = $el.data('price')
      @$currentPrice.data('customization-price', price)
      @$action.html("#{name} +#{price}")

    @close(price)
    
