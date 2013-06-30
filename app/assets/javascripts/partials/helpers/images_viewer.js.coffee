window.helpers or= {}

window.helpers.buildImagesViewer = () ->
  viewer =  {
    currentImages: null
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
      $('#photos .big-photo img').attr(src: largeImage)

    showBigImage: () ->
      bigImageUrl = viewer.currentImages.original
      return if !bigImageUrl?
  }

  return viewer
