add_image_handlers = ->
  thumbnails = ($ '#product-images ul.thumbnails')
  ($ '#main-image').data 'selectedThumb', ($ '#main-image img').attr('src')
  thumbnails.find('li').eq(0).addClass 'selected'
  thumbnails.find('a').on 'click', (event) ->
    ($ '#main-image').data 'selectedThumb', ($ event.currentTarget).attr('href')
    ($ '#main-image').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
    ($ this).mouseout ->
      thumbnails.find('li').removeClass 'selected'
      ($ event.currentTarget).parent('li').addClass 'selected'
    false

  thumbnails.find('li').on 'mouseenter', (event) ->
    ($ '#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

  thumbnails.find('li').on 'mouseleave', (event) ->
    ($ '#main-image img').attr 'src', ($ '#main-image').data('selectedThumb')

show_variant_images = (variant_id) ->
  ($ 'li.vtmb').hide()
  ($ 'li.tmb-' + variant_id).show()
  currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
  if not currentThumb.hasClass('vtmb-' + variant_id)
    thumb = ($ ($ '#product-images ul.thumbnails li:visible.vtmb').eq(0))
    thumb = ($ ($ '#product-images ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
    newImg = thumb.find('a').attr('href')
    ($ '#product-images ul.thumbnails li').removeClass 'selected'
    thumb.addClass 'selected'
    ($ '#main-image img').attr 'src', newImg
    ($ '#main-image').data 'selectedThumb', newImg
    ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

update_variant_price = (variant) ->
  variant_price = variant.data('price')
  ($ '.price.selling').text(variant_price) if variant_price

$ ->
  radios = ($ '#product-variants input[type="radio"]')
  add_image_handlers()

  if radios.length > 0
    show_variant_images radios.eq(0).attr('value') 
    update_variant_price radios.first()

  ($ '#product-variants input[type="radio"]').click (event) ->
    show_variant_images @value
    update_variant_price ($ this)
