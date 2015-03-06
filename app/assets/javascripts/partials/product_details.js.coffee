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
  slider     = new helpers.ProductImagesSlider(options.slider.container, options.slider.images, options.slider.options)
  selector   = new window.helpers.ProductVariantsSelector(options.selector)
  customizer = new page.ProductCustomisation(options.customize)
  colorizer  = new page.ProductColorizer(options.colorize, slider)
  sizer      = new page.ProductSizer(options.size)

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
        window.helpers.showAlert(message: status.error)
      else
        selected = selector.getCurrentSelection()
        product_data = {
          size_id: selected.size_id,
          color_id: selected.color_id,
          customizations_ids: selected.customizations_ids
          variant_id: (selected.variant || {})['id']
        }
        app.shopping_cart.one('change', () ->
          window.helpers.showAlert(message: 'Added to Cart', type: 'success')
          window.app.shopping_bag.open()
        )
        app.shopping_cart.addProduct(product_data)
    )

  if options.fitguideButton
    $(options.fitguideButton).on('click', (e) ->
      e.preventDefault()
      window.helpers.showModal(title: 'Size Guide', className: 'fit-guide', container: options.fitguideContainer)
    )
    
  # init moodboard button
  if options.wishlistButton
    $wishlist_button = $(options.wishlistButton)
    $wishlist_button.on('click', (e) ->
      e.preventDefault()
      
      # unless $(this).data('user-present')
      # redirect to login 

      status = selector.validate()
      if !status.valid
        window.helpers.showAlert(message: status.error)
      else
        selected = selector.getCurrentSelection()
        wishlist_item_data = {
          color_id: selected.color_id,
          variant_id: (selected.variant || {})['id'],
          product_id: selected.product_id
        }
        app.user_moodboard.addItem(wishlist_item_data)
    )

    updateWishlistButtonState = () ->
      data = selector.getCurrentSelection()
      if app.user_moodboard.contains({ product_id: data.product_id, color_id: data.color_id })
        $wishlist_button.attr('disabled', true)
      else
        $wishlist_button.removeAttr('disabled')

    selector.on('change', updateWishlistButtonState)
    app.user_moodboard.on('change', updateWishlistButtonState)
    updateWishlistButtonState() # set current state

  # recommended dreses - add to moodboard button functionality
  if options.moodboard_links
    addProductToMoodboardHandler = (e) ->
      e.preventDefault()
      product_id = $(e.currentTarget).closest('div[data-id]').data('id')
      app.user_moodboard.addItem({ product_id: product_id })

    refreshButtonsState = (e) ->
      $(options.moodboard_links.container).find(options.moodboard_links.buttons).each((index, item) ->
        product_id = $(item).closest('div[data-id]').data('id')
        if app.user_moodboard.contains({ product_id: product_id })
          $(item).addClass('fa-heart').removeClass('fa-heart-o')
        else
          $(item).removeClass('fa-heart').addClass('fa-heart-o')
      )

    $(options.moodboard_links.container).on(
      'click', options.moodboard_links.buttons, addProductToMoodboardHandler
    )
    app.user_moodboard.on('change', refreshButtonsState)
