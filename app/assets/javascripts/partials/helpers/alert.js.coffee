window.helpers or= {}

window.helpers.showAlert = (opts) ->
  type = opts.type || 'warning'
  if type == 'success'
    title = opts.title || "awesome babe"
    icon = 'fa-heart-o'
  else
    title = opts.title || "sorry babe"
    icon = 'fa-frown-o'

  message = "<h3>#{title}</h3><p><span class=\"fa fa-icon #{icon}\"></span> #{opts.message}</p>"

  vex.dialog.buttons.YES.text = 'X'

  dialog = vex.dialog.alert
    message: message
    className: "vex vex-theme-bottom-right-corner alert alert-#{type} #{opts.className || ''}"
    afterOpen: ->
      $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY

  dialogID = dialog.data().vex.id
  closeAlert = =>
    vex.closeByID(dialogID)

  setTimeout(closeAlert, opts.timeout || 5555)
