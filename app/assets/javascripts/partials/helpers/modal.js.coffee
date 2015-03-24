window.helpers or= {}


window.helpers.showModal = (opts) ->
  className = opts.className || ''
  vex.dialog.buttons.YES.text = ''
  vex.dialog.alert
    title: opts.title || title
    message: $(opts.container).html()
    className: "vex vex-theme-flat-attack #{className}"
    afterOpen: ->
      $('.vex-dialog-button-primary').addClass('btn btn-black')
      $('.vex-dialog-button-primary').removeClass('vex-dialog-button')
      $('body').addClass('no-scroll')
      $('a.modal-close').on('click', ->
        vex.close()
      )
    afterClose: ->
      $('body').removeClass('no-scroll')
