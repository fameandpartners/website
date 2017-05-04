page.initProductDetailsPage = (options = {}) ->
  parseNumber = (string) ->
    parseInt(string) || null

  # After user clicks the ADD TO CART button, react selector will populate
  # on page hidden form and trigger submit.
  $(document).on('submit', '#pdpDataForCheckout', (e) ->
    e.preventDefault()

    $this = $(this)

    # Really really bad and CRINGEWORTHY, TODO: REFACTOR
    product_data = {
      size_id:            parseNumber($this.find('#pdpCartSizeId').val()),
      color_id:           parseNumber($this.find('#pdpCartColorId').val()),
      variant_id:         parseNumber($this.find('#pdpCartVariantId').val()),
      making_options_ids: parseNumber($this.find('#pdpCartMakingId').val()),
      height_value:       parseNumber($this.find('#pdpCartHeight').val()),
      height_unit:        $this.find('#pdpCartHeightUnit').val(),
      customizations_ids: $this.find('#pdpCartCustomId').val().split(','),
      dress_variant_id:   parseNumber($this.find('#pdpCartDressVariantId').val())
    }

    app.shopping_cart.one('change', window.app.shopping_bag.open)
    app.shopping_cart.addProduct(product_data)
  )

  # redirect not loged-in users
  $('.js-add-to-moodboard').on('click', (e) ->
    e.preventDefault()
    if !app.user_signed_in
      window.redirectToLoginAndBack()
    return
  )
