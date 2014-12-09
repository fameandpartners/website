window.helpers or= {}
window.helpers.createProductImagesSlider = (container, input) ->
  bxSlider = null
  $container = $(container)
  $colorInput = input

  all_slides = $container.find('li').remove()

  sliderSettings = {
    controls: true,
    nextText: '<span class="icon-arrow-right" />',
    prevText: '<span class="icon-arrow-left" />'
  }

  updateSliderImages = () ->
    # get current slide id 
    currentSlideIndex = bxSlider.getCurrentSlide()
    currentSlideId = $($container.find('li')[currentSlideIndex]).attr('id')

    # get new slides set
    colorId = $colorInput.getOptionValueId()
    selected_slides = _.filter(all_slides, (slide) ->
      $(slide).data('color-id') == colorId
    )
    selected_slides = all_slides if selected_slides.length == 0
    $container.html(selected_slides)

    # reload slider and set to previous slide
    if !!currentSlideId && $container.find("##{ currentSlideId }").length > 0
      startSlide = $container.find("##{ currentSlideId }").index()
    else
      startSlide = 0

    bxSlider.reloadSlider(_.extend({ startSlide: startSlide }, sliderSettings))

  bxSlider = $container.bxSlider(sliderSettings)

  $colorInput.on('change', updateSliderImages)
  updateSliderImages()
