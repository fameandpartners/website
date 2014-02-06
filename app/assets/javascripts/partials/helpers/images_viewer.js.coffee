window.helpers ||= {}

window.helpers.buildImagesViewer = (rootElement) ->
  rootElement = rootElement

  viewer =  {
    currentImages: null
    init: () ->
      rootElement.find('ul#product-images li a').on("click", viewer.onClickHandler)
      rootElement.find('#photos .big-photo .zoom .icon-zoom-in').on('click', viewer.showFullImageEventHandler)
      viewer.showImageFromItem(rootElement.find('ul#product-images li:first a'))
      return viewer

    onClickHandler: (e) ->
      e.preventDefault()
      viewer.showImageFromItem.call(viewer, $(e.currentTarget))

    showFullImageEventHandler: (e) ->
      e.preventDefault()
      viewer.showBigImage.call(viewer)

    showImageFromItem: (carouselItem) ->
      if !carouselItem? || carouselItem.length != 1
        return false
      images = carouselItem.data()

      carouselItem.closest('li').addClass('selected').siblings().removeClass('selected')
      @showImage(images)

    showImage: (images) ->
      viewer.currentImages = images
      largeImage = images.large || 'http://placehold.it/460x590'
      rootElement.find('#photos .big-photo img').attr(src: largeImage).css('display', 'block').css('visibility', 'visible')

    showBigImage: () ->
      bigImageUrl = viewer.currentImages.xlarge
      if bigImageUrl?
        bigImageUrl = (location.origin + bigImageUrl) if !bigImageUrl.match(/^https?:\/\//)
        $.fancybox href: bigImageUrl
      else
        return false
  }

  return viewer
