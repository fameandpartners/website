# notes:
# functions for this object:
#   - preloading images
#   - switching between colors: ready
#   - autoscroll: ready
#

# display slider for first image. 
# load all the images
# update slider

window.helpers or= {}
window.helpers.ProductImagesSlider = class ProductImagesSlider
  constructor: (container, images, options = {}) ->
    @options    = options || {}
    @$container = $(container || '#slides')
    @images = images    
    @all_images = @$container.find('.slides-container').find('img').remove()
    @images_color_id = @options.preselected
    @options.preselected = null
    @updateSlider()

    @preload()      

  showImagesWithColor: (color_id) =>    
    return if @images_color_id == color_id
    @images_color_id = parseInt(color_id)
    @updateSlider()

  updateSlider: () =>
    selected_images = _.filter(@all_images, (image) ->
      $(image).data('color-id') == @images_color_id
    , @)
    selected_images = @all_images if selected_images.length == 0
    # #note - this row don't work, so we use remove/html/paste instead
    # @$container.find('.slides-container').html(selected_images)
    @$container.superslides('destroy')
    wrapper = @$container.find('.slides-container').remove()
    wrapper.html(selected_images)
    @$container.html(wrapper)  
    @$container.superslides(@options)

  preload: () =>
    @progress = 0
    @preloadImages = _.map @images, (image) =>
      s = "<img         
        id='product-image-slide-#{image.id }'         
        class='product-image-slide' 
        alt='#{ image.alt }' 
        data-color-id='#{ image.color_id }' 
        style='height: 1164px; width: 2560px; overflow: hidden;'
        />"
      img = $(s)[0]      
      img.onload = @imageLoaded
      img.src = image.url;            
      img 
  
  # bit unsure about managing state like this, but it works.     
  imageLoaded: () =>
    @progress++
    if @progress == @images.length    
      @all_images = @preloadImages
      @updateSlider()
  
