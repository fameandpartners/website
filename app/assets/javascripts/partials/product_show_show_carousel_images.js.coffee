$(".products.show").ready ->
  viewer = {
    currentImages: null
    onClickHandler: (e) ->
      e.preventDefault()
      viewer.showImageFromItem($(e.currentTarget))

    showFullImageEventHandler: (e) ->
      e.preventDefault()
      viewer.showBigImage()

    showImageFromItem: (carouselItem) ->
      if !carouselItem? || carouselItem.length != 1
        return false
      images = carouselItem.data()

      carouselItem.closest('li').addClass('selected').siblings().removeClass('selected')
      viewer.showImage(images)

    showImage: (images) ->
      viewer.currentImages = images
      largeImage = images.large || 'http://placehold.it/460x590'
      $('#photos .big-photo img').attr(src: largeImage)

    showBigImage: () ->
      bigImageUrl = viewer.currentImages.original
      return if !bigImageUrl?
      alert("show tab/popup with image '#{bigImageUrl}'")
  }

  $('ul#product-images li a').on("click", viewer.onClickHandler)
  $('#photos .big-photo .zoom a').on('click', viewer.showFullImageEventHandler)

  viewer.showImageFromItem($('ul#product-images li a').first())
