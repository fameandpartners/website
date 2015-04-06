window.popups or= {}
window.page or= {}

# style quiz popup
# - popup with iframe inside
# - should handle open/close/iframe reload

window.showQuizPopup = () ->
  iframe = $('<iframe />', src: urlWithSitePrefix('/style_quiz'), frameBorder: '0', width: '1102px', height: '680px')
  content = $("<div />", id: 'quiz_popup').html(iframe)

  vex.open({
    content: content
    className: 'vex-dialog-default vex-dialog-quiz'
    afterOpen: ($vexContent) ->
      "after open placeholer"
    afterClose: ($vexContent) ->
      "after close placeholer"
  })

window.onQuizCompleted = () ->
  # attach redirects to style profile?
  #console.log('onQuizCompleted - parent')
