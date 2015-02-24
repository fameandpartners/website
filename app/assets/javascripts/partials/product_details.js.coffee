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
  slider      = null
  selector    = null

  # init slider images
  slider    = new helpers.ProductImagesSlider(options.slider.container, options.slider.images, options.slider.options)
  selector  = new window.helpers.ProductVariantsSelector(options.selector)

  # change images colors
  selector.on('change', (event, data) ->
    slider.showImagesWithColor(data.color_id)
  )

  # init buy button
  if options.buyButton
    $(options.buyButton).on('click', (e) ->
      e.preventDefault()
      status = selector.validate()
      if !status.valid
        window.helpers.showErrors($(e.currentTarget), status.error)
      else
        console.log('shopping cart works here')
    )

  # init moodboard button
  if options.wishlistButton
    $(options.wishlistButton).on('click', (e) ->
      e.preventDefault()
      status = selector.validate()
      if !status.valid
        window.helpers.showErrors($(e.currentTarget), status.error)
      else
        console.log('toggle product wishlist state')
    )
