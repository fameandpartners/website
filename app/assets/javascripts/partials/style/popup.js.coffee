window.popups or= {}
window.page or= {}

# style quiz popup
# - popup with iframe inside
# - should handle open/close/iframe reload

window.showQuizPopup = () ->
  iframe = $('<iframe />',
    src: urlWithSitePrefix('/style_quiz'),
    width: '500px',
    height: '600px'
  )
  content = $("<div  />", id: 'quiz_popup').html(iframe)

  vex.open({
    content: content,
    className: 'vex-dialog-default vex-dialog-pink vex-dialog-signup'
  })
