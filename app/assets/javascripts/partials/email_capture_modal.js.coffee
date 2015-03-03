window.page or= {}

window.page.EmailCaptureModal = class EmailCaptureModal
  constructor: (opts = {}) ->            
    @opts = opts
    timeout = opts.timeout || 0    
    @$container = $(opts.container)
    
    setTimeout(@open, timeout) #if $.cookie('email_capture') != 'hide'

  afterClose: () ->
    # $.cookie('email_capture', 'hide', { expires: 365, path: '/' })

  callback: (data) =>            
    if data 
      @process(data)
    else
      # window.track.event('LandingPageModal', 'ClosedNoAction', @opts.content, @opts.promocode)

  process: (data) =>
    console.log('process') 
    if !!data.email
      $.post(@opts.action, data).done(@success).fail(@error)    
    else          
      window.helpers.showAlert(message: 'Did you mean to forget your email address?', timeout:5555)

  success: (data) =>  
    if data.status == 'ok'
      title = '#hashtag #hooray'

      if @opts.promocode
        message = "Thanks for joining! Use this promocode for your next killer dress: #{@opts.promocode}."
      else
        message = "Thanks for joining!"

      window.helpers.showAlert(message: message, title: title, timeout: 55555)

  failure: () =>
    window.helpers.showAlert(message: 'Is your email address correct?', timeout:5555)    
    # window.track.event('EmailCaptureModal', 'Error', @campaign)

  onOpen: =>
    $('.vex-dialog-buttons button').addClass('btn btn-black') # HACKETRY
    if @opts.submitText
      $('.vex-dialog-form button[type=submit]').val(@opts.submitText) 

    # window.track.event('LandingPageModal', 'Opened', @opts.content, @opts.promocode)

  open: () =>
    vex.dialog.buttons.NO.text = 'X'
    vex.dialog.open      
      className: "vex vex-theme-flat-attack email-capture-modal #{@opts.className || ''}" 
      input: @$container.html()
      message: @opts.message || ''
      afterOpen: @onOpen    
      afterClose: @onClose
      callback: @callback


    