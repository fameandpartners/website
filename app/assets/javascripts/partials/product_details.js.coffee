page.initProductDetailsPage = (options = {}) ->
  # After user clicks the ADD TO CART button, react selector will populate
  # on page hidden form and trigger submit.
  $(document).on('submit', '#pdpDataForCheckout', (e) ->
    e.preventDefault()

    $this = $(this)
    dressVarId = undefined
    customIds = undefined
    if $this.find('#pdpCartVariantId').val()
      dressVarId = parseInt($this.find('#pdpCartDressVariantId').val())
    if $this.find('#pdpCartCustomId').val()
      customIds = parseInt($this.find('#pdpCartCustomId').val())

    product_data = {
      size_id:            parseInt($this.find('#pdpCartSizeId').val()),
      color_id:           parseInt($this.find('#pdpCartColorId').val()),
      variant_id:         parseInt($this.find('#pdpCartVariantId').val()),
      making_options_ids: $this.find('#pdpCartMakingId').val(),
      height:             $this.find('#pdpCartLength').val(),
      customizations_ids: customIds
    }

    if dressVarId
      product_data.dress_variant_id = dressVarId

    app.shopping_cart.one('change', () ->
      window.app.shopping_bag.open()
    )
    app.shopping_cart.addProduct(product_data)
  )

  # redirect not loged-in users
  $('.js-add-to-moodboard').on('click', (e) ->

    e.preventDefault()
    if !app.user_signed_in
      window.redirectToLoginAndBack()
      return
  )
