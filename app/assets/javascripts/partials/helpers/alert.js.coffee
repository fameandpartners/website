window.helpers or= {}

window.helpers.showAlert = (opts) ->
  type = opts.type || 'warning'
  className = '' #opts.className || 'product-select-alert'
  vex.defaultOptions.className = 'vex-theme-bottom-right-corner'
  vex.dialog.alert
    message: opts.message 
    className: "vex vex-theme-bottom-right-corner #{opts.className}" 
    contentClassName: "alert alert-#{type} vex-content"
  setTimeout(vex.close, opts.timeout || 2222)