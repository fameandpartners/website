# notes:
# functions for this object:
#   - preloading images
#   - switching between colors
#   - autoscroll

# display slider for first image.
# load all the images
# update slider

window.helpers or= {}
window.helpers.ProductImagesSlider = class ProductImagesSlider
  constructor: (container, @images, options = {}) ->
    @options = $.extend({
      animation: 'fade'
		}, options)

    @$container = $(container || '#slides')
    @$container.superslides(@options)
    @all_images = @$container.find('.slides-container').find('img').clone()

    if @options.preselected
      @images_color_id = parseInt(@options.preselected)
      @options.preselected = null

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
    @$container.find('.slides-container').html(selected_images)
    @$container.superslides('update')

  getLoadImageDeferred: (product_image) =>
    defer = new $.Deferred()

    image = new Image()
    image.onerror = defer.resolve
    image.onload = () =>
      @loaded_images.push($("<img
      id='product-image-slide-#{product_image.id }'
      class='product-image-slide'
      alt='#{ product_image.alt }'
      data-color-id='#{ product_image.color_id }'
      data-position='#{ product_image.position }'
      src='#{ product_image.url }'
      />"))
      defer.resolve(product_image)

    image.src = product_image.url

    defer

  preload: () =>
    @loaded_images = []
    deferrers = _.map @images, (image) =>
      @getLoadImageDeferred(image)

    $.when.apply(this, deferrers).then( () =>
      @all_images = _.sortBy(@loaded_images, (i) ->
        i.data('position')
      )
      @updateSlider()
    )
