$('.profiles.show').ready ->
  updateUserAvatarImage = (img_src) ->
    if $('.avatar-field .avatar img').length > 0
      $('.avatar-field .avatar img').attr(src: img_src)
    else
      $image = $("<img />", {src: img_src, width: '100px'})
      $('.avatar-field .avatar').append($image)
    $('.avatar-field .avatar').removeClass('empty')
    $('.region .loggedin .avatar img').attr(src: img_src)
    $('.region .loggedin .avatar').removeClass('empty')

  submitButtonText = null
  previousAvatarImage = null
  transparentImage = '/assets/transparent.gif'
  spinnerImage = '/assets/spinner-big.gif'
  showSpinner = () ->
    submitButtonText = $('.btn-upload').val()
    previousAvatarImage = $('.avatar-field .avatar img').attr('src')

    $('.btn-upload').attr('disabled', true).val('Loading ...')
    updateUserAvatarImage(transparentImage)
    $('.avatar-field .avatar img').css
      background: 'url('+spinnerImage+') no-repeat transparent center center'


    return true

  hideSpinner = () ->
    $('.btn-upload').removeAttr('disabled').val(submitButtonText)
    $('.avatar-field .avatar img').css('background-image', 'none')
    if $('.avatar-field .avatar img').attr('src') == transparentImage
      updateUserAvatarImage(previousAvatarImage)
    return true

  window.initFileuploader = ->

    authenticity_token = $('meta[name="csrf-token"]').attr('content');

    $('#fileupload').fileupload({
      url: '/profile/update_image'
      dataType: 'json'
      type: 'PUT'
      formData: [
        { name: 'authenticity_token', value: authenticity_token }
      ]
      multipart: true
      paramName: 'image'
      singleFileUploads: true
      send: showSpinner
      always: hideSpinner
      done: (e, data) ->
        updateUserAvatarImage(data.result.image)
    })

    $('.btn-upload').on('click', (e) ->
      e.preventDefault()
      e.stopPropagation()

      $('#fileupload').click()
    )

  window.initFileuploader() 
