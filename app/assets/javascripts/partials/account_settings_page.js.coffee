$('.profiles.show').ready ->
  updateUserAvatarImage = (img_src) ->
    if $('.avatar-field .avatar img').length > 0
      $('.avatar-field .avatar img').attr(src: img_src)
    else
      $image = $("<img />", {src: img_src})
      $('.avatar-field .avatar').append($image)
    $('.avatar-field .avatar').removeClass('empty')

  showSpinner = () ->
    return true

  hideSpinner = () ->
    return true

  window.initFileuploader = ->
    $('#fileupload').fileupload({
      url: '/profile/update_image'
      dataType: 'json'
      type: 'PUT'
      formData: {}
      multipart: true
      paramName: 'image'
      singleFileUploads: true
      send: (e, data) ->
        showSpinner()
      done: (e, data) ->
        hideSpinner()
        updateUserAvatarImage(data.result.image)
    })

    $('.btn-upload').on('click', (e) ->
      e.preventDefault()
      e.stopPropagation()

      $('#fileupload').click()
    )

  window.initFileuploader()
