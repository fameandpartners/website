window.helpers or= {}

window.helpers.createNewProductPageSelector = (parentContainer) ->
  personalisationForm = {
    container: parentContainer,
    sizeInput: null,
    colorInput: null,
    customisationsInput: null,
    incompatibility_map: {},
    selected: {
      color: null,
      size: null,
      customization_value_ids: []
    },
    variants:   null,
    masterVariantId: null,
    choosenVariantId: null,
    errorMessage: 'please, select size and color'

    init: (variants, master_id, incompatibility_map) ->
      personalisationForm.__init.apply(personalisationForm, arguments)

    __init: (variants, master_id, incompatibility_map) ->
      _.bindAll(@, 'update')
      _.bindAll(@, 'onBuyButtonClickHandler')
      _.bindAll(@, 'trackCustomisationSelected')

      @variants = variants
      @masterVariantId  = master_id
      @incompatibility_map = incompatibility_map

      @sizeInput  or= new window.inputs.ChosenSelector(@container.find('select#size'), 'integer')
      @colorInput or= new window.inputs.GroupedOptionsChosenSelector(@container.find('select#colour'))
      @colorInput.val('')

      @customisationsInput or= new window.inputs.CustomisationsSelector(
        @container.find('.customisation-selector').parent(),
        @incompatibility_map
      )

      @sizeInput.on('change',  @update)
      @colorInput.on('change',  @update)
      @customisationsInput.on('change', @update)
      #@customisationsInput.on('change', @trackCustomisationSelected)

      @container.find('.product-info .btn[data-action=buy]').on('click', @onBuyButtonClickHandler)
      @update()

    update: () ->
      @selected = {
        size: @sizeInput.val(),
        color: @colorInput.val(),
        customization_value_ids: @customisationsInput.val()
      }
      @updateChoosenVariantId()
      @updateWishlistButton()
      @updateBuyButton()
      @updateSendToFriendButton()
      @container.trigger('selection_changed', @selected)
      @container.data('selected', @selected)
      return true

    isCustomProduct: () ->
      return true if !_.isEmpty(@selected.customization_value_ids)
      return @colorInput.isCustomOption()

    updateChoosenVariantId: () ->
      @choosenVariantId = null

      window.helpers.hideErrors(@container.find('.product-info'))

      if !_.isFinite(@selected.size) && _.isEmpty(@selected.color)
        @errorMessage = 'Please, select size and color'
      else if !_.isFinite(@selected.size)
        @errorMessage = 'Please, select size'
      else if _.isEmpty(@selected.color)
        @errorMessage = 'Please, select color'
      else
        if @isCustomProduct()
          @choosenVariantId = @masterVariantId
          @errorMessage = null
        else
          variant = _.findWhere(@variants, { size: @selected.size, color: @selected.color })
          if _.isEmpty(variant)
            @errorMessage = 'Sorry, this combination unavailable'
          else
            @errorMessage = null
            @choosenVariantId = variant.id
      return @choosenVariantId

    updateWishlistButton: () ->
      $button = @container.find('.btn.wish-list-link')
      $button.data('color-id', @colorInput.getOptionValueId())

      if @choosenVariantId
        $button.data(id: @choosenVariantId)
      else
        $button.data(id: @masterVariantId)

    updateBuyButton: () ->
      $button = @container.find('.product-info .btn.buy-now')
      #if @isCustomProduct()
      #  $button.html('add customised product to cart')
      #else
      #  $button.html('add to cart')

      $button.data(id: @choosenVariantId, error: @errorMessage)

      return true

    updateSendToFriendButton: () ->
      $button = @container.find('.product-info .btn.send-to-bride')
      $button.data(id: @choosenVariantId, error: @errorMessage, selected: @selected)

    trackCustomisationSelected: (e) ->
      if !_.isEmpty(@customisationsInput.val())
        track.selectedCustomisation(window.product_analytics_label)

    onBuyButtonClickHandler: (e) ->
      e.preventDefault()
      e.stopImmediatePropagation()

      if !!@choosenVariantId
        @buyProduct()
      else
        window.helpers.showErrors($(e.currentTarget).parent(), @errorMessage)

    buyProduct: () ->
      $button = @container.find('.product-info .btn.buy-now')
      $button.addClass('adding')

      options = {
        failure: () -> $button.removeClass('adding')
        success: (data) ->
          $button.removeClass('adding').addClass('added')
          track.addedToCart(data.analytics_label) if data.analytics_label?
      }
      if @isCustomProduct()
        options.line_item_personalization = {
          color_name: @selected.color,
          size: @selected.size,
          customization_value_ids: @selected.customization_value_ids
        }
      window.shoppingBag.afterUpdateCallback(window.shoppingBag.showTemporarily)
      window.shopping_cart.addProduct.call(window.shopping_cart, @choosenVariantId, options)
      return
  }

  return personalisationForm

