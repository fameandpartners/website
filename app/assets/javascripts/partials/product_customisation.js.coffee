window.page or= {}

window.page.BaseProductCustomizer = class BaseProductCustomizer
  constructor: (opts = {}) ->        
    @opts = opts

    @$container = $(opts.container)
    @selector = new window.helpers.ProductSideSelectorPanel(@$container)
    @$action = $(opts.action).on('click', @selector.open)    
    @$select = $(opts.select)    
    @$currentPrice = $('#product-current-price')

  hackPriceToCents: (price) ->
  
    if price 
      parseInt(price.toString().replace(/\D/g, ''))
    else 
      0

  close: ()=> 
    # @updatePrice() DONT TURN THIS ON YET
    setTimeout(@selector.close, 50)

  updatePrice: ()=>

    originalPrice = @hackPriceToCents(@$currentPrice.data('original-price'))
    sizePrice = @hackPriceToCents(@$currentPrice.data('size-price'))
    colorPrice = @hackPriceToCents(@$currentPrice.data('color-price'))
    customizationPrice = @hackPriceToCents(@$currentPrice.data('customization-price'))

    price = originalPrice + sizePrice + colorPrice + customizationPrice

    if originalPrice == price     
      @$currentPrice.addClass('hidden').html('')
    else
      f = (price/100).toFixed(2)
      @$currentPrice.removeClass('hidden').html("$#{f}")
    

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
      @$currentPrice.data('size-price', @hackPriceToCents(price))
      @$action.html("#{name} +#{price}")
    else
      @$currentPrice.data('size-price', 0)
      @$action.html(name)

    @close(price)
    
window.page.ProductColorizer = class ProductColorizer extends BaseProductCustomizer
  
  constructor: (opts = {}) ->        
    super(opts)  
    @$container.find('.color-option').on('click', @toggle)

  toggle: (e) =>          
    $el = $(e.currentTarget)
    id = $el.data('id')
    name = $el.data('name')
    price = $el.data('price')

    $(@$container).find('.active').removeClass('active')    
    $el.toggleClass('active')    
    @$select.val(id)

    if price
      @$currentPrice.data('color-price', @hackPriceToCents(price))
      @$action.html("#{name} +#{price}")
      @message = "You have selected a custom color, so we don't have a pic of this dress yet"
    else
      @$currentPrice.data('color-price', 0)
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
      @$currentPrice.data('customization-price', @hackPriceToCents(price))
      @$action.html("#{name} +#{price}")

    @close(price)
    
