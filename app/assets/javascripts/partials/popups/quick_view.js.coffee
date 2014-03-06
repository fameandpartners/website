window.popups or= {}

window.popups.ProductQuickView = class ProductQuickView
  productId: null
  analytics_label: null
  productVariants: []
  productImages: []
  productVideos:  []
  productVideoUrl: null

  constructor: (@productId) ->
    _.bindAll(@, 'hide', 'show', 'showModalWindow', 'renderImages')
    _.bindAll(@, 'track', 'trackPopupOpened')
    _.bindAll(@, 'closeButtonClickHandler')
    _.bindAll(@, 'showProductVideoFor')

    @container = window.popups.getQuickViewModalContainer(null, null)
    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)

    @container.on('click', ".tabs .tabs-links a[href='#videos']", @track('viewVideo'))
    @container.on('click', ".tabs .tabs-links a[href='#inspiration']", @track('viewCelebrityInspiration'))
    @container.on('click', ".buy-wishlist a.btn-layby", @track('laybyButtonClick'))
    @container.on('click', ".product-info .customize a", @track('customDressClick'))

  # external api
  show: () ->
    @popupDataRequest()
      .done(@showModalWindow, @trackPopupOpened)
      .fail(@hide)
  
  hide: () ->
    @container.hide()
    @

  # handlers
  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()
  
  # private functions
  popupDataRequest: () ->
    quickViewUrl = urlWithSitePrefix("/products/#{@productId}/quick_view")
    $.ajax(
      url: quickViewUrl
      type: 'GET'
      dataType: 'json'
      data: $.param({ product_id: @productId })
    )

  showModalWindow: (response) ->
    @productVariants = response.variants
    @productImages = response.images
    @productVideos = response.videos
    @productVideoUrl = response.default_video_url
    @container.find('.product-page').replaceWith(response.popup_html)
    @container.show()
    @container.find('.quick-view').css({width: '900px'}).center()
    @renderImages()
    @updatePopupHandlers()

  trackPopupOpened: (response) ->
    if response.analytics_label
      @analytics_label = response.analytics_label
      track.openedQuickView(response.analytics_label)

  track: (method_name) ->
    track_func = (e) =>
      if !_.isEmpty(@analytics_label)
        track[method_name].call(window, @analytics_label)
    return track_func

  renderImages: () ->
    images_list = @container.find('#product-images').html('')
    _.each(@productImages, (productImage) ->
      image = $("<li><a href='#'><img src='#{ productImage.small }' /></a></li>")
      image.find('a').data(large: productImage.large, xlarge: productImage.xlarge)
      images_list.append(image)
    )
    images_list.waitForImages(() =>
      options =
        prev:
          button: '#quick-view-product-images-up'
        next:
          button: '#quick-view-product-images-down'
      images_list.carouFredSel(
        helpers.get_vertical_carousel_options(options)
      )
      helpers.buildImagesViewer(@container).init()
    )
    return images_list

  updatePopupHandlers: () ->
    window.helpers.enableTabs(@container.find('.tabs'))
    page.enableWhatSizeIam(@container.find('.toggle-sizes'))
    page.enableBuyButton(@container.find('.buy-now'), { expandShoppingBag: false})
    page.enableWishlistLinks(@container.find("a[data-action='add-to-wishlist']"))

    @container.find('.selectbox').chosen(width: '100%', disable_search: true)

    selector = window.helpers.createProductVariantsSelector(@container)
    selector.sizeInput = new inputs.ChosenSelector(@container.find('select#toggle-selectbox'))
    selector.target = @container.find('.buy-wishlist .btn.buy-now')
    selector.init(@productVariants)

    @container.on('selection_changed', (e, filter) =>
      if window.current_product_color != filter.color
        @showProductVideoFor(filter.color)
    )

    window.helpers.initProductReserver(
      @container.find('.twin-alert a.twin-alert-link'),
      @analytics_label,
      () =>
        selected = @container.data('selected')
        if _.isUndefined(selected) || _.isNull(selected.color)
          return null
        else
          return selected.color
    )

  showProductVideoFor: (color) ->
    $player = @container.find('#videos iframe')
    return if $player.length == 0 # for non-video layout..
    new_video = _.findWhere(@productVideos, { color: color })
    if _.isEmpty(new_video)
      new_video_url = @productVideoUrl
    else
      new_video_url = new_video.video_url
    $player.attr('src', new_video_url)
