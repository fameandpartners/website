# usage
#  page.initProductDetailsPage(
#    slider: {
#      container: '#slides',
#      options: { animation: 'fade', play: 6000 },
#    },
#    options_select: {
#      variants: [],
#      container: '',
#    },
#    buyButton: '.buy-button',
#    wishlistButton: '.moodboard-button'
# );

page.initProductDetailsPage = (options = {}) ->
  slider    = null
  selector  = null

  # init slider images
  if options.slider
    slider = window.helpers.createProductImagesSlider(options.slider.container, options.slider.options)

  # variants selector
  if options.selector
    selector = new window.helpers.ProductVariantsSelector(options.selector)
    selector.on('change', () -> console.log('smthing changed'))

  # init buy button

  # init moodboard button
