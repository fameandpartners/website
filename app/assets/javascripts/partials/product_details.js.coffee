$(document).on('submit', '#pdpDataForCheckout', () ->
  $this = $(this)
  product_data = {
    size_id:            $this.find('#pdpCartSizeId').val(),
    color_id:           $this.find('#pdpCartColorId').val(),
    customizations_ids: $this.find('#pdpCartCustomId').val(),
    making_options_ids: $this.find('#pdpCartMakingId').val(),
    variant_id:         $this.find('#pdpCartVariantId').val(),
    dress_variant_id:   $this.find('#pdpCartDressVariantId').val(),
    height:             $this.find('#pdpCartLength').val()
  }
  app.shopping_cart.one('change', () ->
    window.app.shopping_bag.open()
  )
  app.shopping_cart.addProduct(product_data)
)



# usage
#  page.initProductDetailsPage(
#    options_select: {
#      variants: [],
#      container: '',
#    },
#    buyButton: '.buy-button',
#    wishlistButton: '.moodboard-button'
# );

page.initProductDetailsPage = (options = {}) ->
  selector    = null
  selector   = new window.helpers.ProductVariantsSelector(options.selector)

  # if user selects 'red' color, then change path to /dresses/slug/red
  # don't do this for products without color
  product_paths = options.product_paths
  changeUrlToSelectedColor = (color_id) ->
    if product_paths
      if product_paths[color_id]
        url = product_paths[color_id]
      else
        url = product_paths.default

      window.history.replaceState({ path: url }, '', url)

  # ensure location color according to preselected color
  selected = selector.getValue()

  # change images colors
  selector.on('change', (event, data) ->
    changeUrlToSelectedColor(data.color_id)
    # Push Generic change event with updated selection options.
    window.app.events.trigger('productSelectionOptionsChange', data)
  )

  # init buy button
  if options.buyButton
    $(options.buyButton).on('click', (e) ->
      e.preventDefault()
      status = selector.validate()
      if !status.valid
        window.helpers.showAlert(message: status.error)
      else
        $(options.buyButton).prop('disabled', true)
        $(options.buyButton).html('Adding to cart...')
        selected = selector.getCurrentSelection()
        product_data = {
          size_id:            selected.size_id,
          color_id:           selected.color_id,
          customizations_ids: selected.customizations_ids,
          making_options_ids: selected.making_options_ids,
          variant_id:         (selected.variant || {})['id'],
          dress_variant_id:   (selected.dress_variant || {})['id']
          height:             selected.height
        }
        app.shopping_cart.one('change', () ->
          window.app.shopping_bag.open()
        )
        app.shopping_cart.addProduct(product_data)
    )

  if options.fitguideButton
    $(options.fitguideButton).on('click', (e) ->
      e.preventDefault()
      modal = new window.modals.FitGuideModal(container: options.fitguideContainer)
      modal.show()
    )

  # init moodboard button
  if options.wishlistButton
    $wishlist_button = $(options.wishlistButton)
    $wishlist_button.on('click', (e) ->
      e.preventDefault()

      if !app.user_signed_in
        window.redirectToLoginAndBack()
        return

      # unless $(this).data('user-present')
      # redirect to login
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
      return if $(e.currentTarget).data('loading')
      $(e.currentTarget).data('loading', true)

      product_id = $(e.currentTarget).closest('div[data-id]').data('id')

      if !app.user_signed_in
        window.redirectToLoginAndBack()
        return

      if app.user_moodboard.contains({product_id: product_id })
        url = urlWithSitePrefix('/wishlist')
        window.history.replaceState({ path: url }, '', url)
        widnow.location.href = url
        return

      app.user_moodboard.addItem({ product_id: product_id })

    refreshButtonsState = (e) ->
      $(options.moodboard_links.container).find(options.moodboard_links.buttons).each((index, item) ->
        $(item).data('loading', false)
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
