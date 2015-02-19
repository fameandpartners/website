# notes:
# functions for this object:
#   - preloading images
#   - switching between colors: ready
#   - autoscroll: ready
#
window.helpers or= {}
window.helpers.ProductImagesSlider = class ProductImagesSlider
  constructor: (container, options = {}) ->
    @options    = options || {}
    @$container = $(container || '#slides')
    @all_images = @$container.find('.slides-container').find('img').remove()

    @images_color_id = @options.preselected
    @options.preselected = null

    @updateSlider()

  showImagesWithColor: (color_id) =>
    return if @images_color_id == color_id
    @images_color_id = color_id
    @updateSlider()

  updateSlider: () =>
    selected_images = _.filter(@all_images, (image) ->
      $(image).data('color-id') == @images_color_id
    , @)
    selected_images = @all_images if selected_images.length == 0

    # note - this row don't work, so we use remove/html/paste instead
    # @$container.find('.slides-container').html(selected_images)
    @$container.superslides('destroy')
    wrapper = @$container.find('.slides-container').remove()
    wrapper.html(selected_images)
    @$container.html(wrapper)
    @$container.superslides(@options)
