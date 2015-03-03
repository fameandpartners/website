window.helpers or= {}

window.helpers.showAlert = (opts) ->
  type = opts.type || 'warning'
  className = '' #opts.className
  vex.defaultOptions.className = 'vex-theme-bottom-right-corner'

  title = opts.title || "#hashtag #sorry"
  message = "<h3>#{title}</h3><p>#{opts.message}</p>"

  vex.dialog.alert
    message: message
    className: "vex vex-theme-bottom-right-corner #{opts.className}" 
    contentClassName: "alert alert-#{type} vex-content"
    afterOpen: -> 
      $('.vex-dialog-buttons button').removeClass('vex-dialog-button-primary vex-dialog-button vex-first vex-last').addClass('btn btn-black')
    
    setTimeout(vex.close, opts.timeout || 2222)