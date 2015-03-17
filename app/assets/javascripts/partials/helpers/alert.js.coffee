window.helpers or= {}

window.helpers.showAlert = (opts) ->
  type = opts.type || 'warning'
  if type == 'success'
    title = opts.title || "#hashtag #awesome"
    icon = 'fa-heart-o'
  else
    title = opts.title || "#hashtag #sorry"
    icon = 'fa-frown-o'

  message = "<h3>#{title}</h3><p><span class=\"fa fa-icon #{icon}\"></span> #{opts.message}</p>"

  vex.dialog.buttons.YES.text = 'X'
  vex.dialog.alert
    message: message
    className: "vex vex-theme-bottom-right-corner alert alert-#{type} #{opts.className || ''}"
    afterOpen: ->
      $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY

  setTimeout(vex.close, opts.timeout || 5555)
