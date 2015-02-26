window.helpers or= {}

window.helpers.showAlert = (opts) ->
  vex.defaultOptions.className = 'vex-theme-bottom-right-corner'
  vex.dialog.alert
    message: opts.message 
    className: "vex vex-theme-bottom-right-corner #{opts.className}" 
    contentClassName: 'alert alert-warning vex-content'
  setTimeout(vex.close, opts.timeout || 2222)
