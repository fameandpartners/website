$(document).on('submit', '#pdpDataForCheckout', () ->
  $this = $(this)
  dressVarId = undefined
  customIds = undefined
  if $this.find('#pdpCartVariantId').val()
    dressVarId = parseInt($this.find('#pdpCartVariantId').val())
  if $this.find('#pdpCartCustomId').val()
    customIds = parseInt($this.find('#pdpCartCustomId').val())

  product_data = {
    size_id:            parseInt($this.find('#pdpCartSizeId').val()),
    color_id:           parseInt($this.find('#pdpCartColorId').val()),
    variant_id:         parseInt($this.find('#pdpCartVariantId').val()),
    making_options_ids: $this.find('#pdpCartMakingId').val(),
    height:             $this.find('#pdpCartLength').val(),
    customizations_ids: customIds,
    dress_variant_id:   dressVarId
  }

  app.shopping_cart.one('change', () ->
    window.app.shopping_bag.open()
  )
  app.shopping_cart.addProduct(product_data)
)

page.initProductDetailsPage = (options = {}) ->
  selector    = null
  selector   = new window.helpers.ProductVariantsSelector(options.selector)

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
