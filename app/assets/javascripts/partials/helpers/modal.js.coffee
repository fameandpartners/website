window.helpers or= {}

window.helpers.showModal = (opts) ->
  popup = new window.modals.BaseModal(opts)
  popup.show()

window.modals or= {}

window.modals.BaseModal = class BaseModal
  constructor: (opts = {}) ->
    @opts = opts

  className: () ->
    name = @opts.className || ''
    "vex vex-theme-flat-attack #{name}"

  title: () ->
    @opts.title

  message: () ->
    $(@opts.container).html()

  afterOpen: () ->
    #console.log('after open', arguments)
    # do nothing

  show: () ->
    _afterOpen = @afterOpen
    vex.dialog.buttons.YES.text = ''
    vex.dialog.alert
      title: @title()
      message: @message()
      className: @className()
      afterOpen: ->
        $('.vex-dialog-button-primary').addClass('btn btn-black')
        $('.vex-dialog-button-primary').removeClass('vex-dialog-button')
        $('body').addClass('no-scroll')
        _afterOpen(@)
        $('a.modal-close').on('click', ->
          vex.close()
        )
      afterClose: ->
        $('body').removeClass('no-scroll')
    @

window.modals.FitGuideModal = class FitGuideModal extends BaseModal
  constructor: (opts = {}) ->
    @opts = opts
    @opts.title     ||= 'Size Guide'
    @opts.className ||= 'fit-guide-dialog'
    @opts.container ||= '#fit-guide-content'

  afterOpen: () ->
    windowWidth = $(window).width()
    fitGuideMinWidth = 640
    fitGuideMinHeight = 547
    scale = windowWidth / fitGuideMinWidth
    if scale < 1
      $('.fit-guide-schema').css
        marginBottom: (fitGuideMinHeight * scale) - fitGuideMinHeight
        '-webkit-transform': 'scale('+scale+')'
        '-ms-transform': 'scale('+scale+')'
        '-o-transform': 'scale('+scale+')'
        'transform': 'scale('+scale+')'
