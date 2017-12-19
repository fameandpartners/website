window.page or= {}

window.page.CheckoutModal = class CheckoutModal
  constructor: (opts = {}) ->
    @opts = opts
  message: =>
    h = if @opts.heading then "<h2>#{@opts.heading}</h2>" else ''
    str = "#{h}<p>#{@opts.message}</p>"
  open: () =>
    vex.dialog.open
      className: "vex vex-theme-flat-attack #{@opts.className || ''}"
      input: @$container.html()
      message: @message()

window.page.FlexibleReturnsModal = class FlexibleReturnsModal extends CheckoutModal
  constructor: (opts = '') ->
    modalHeading = 'Want fully flexible returns?'
    modalBody = 'Since every Fame and Partners piece is tailor-made to fit your specific body and personal style, we only offer store credit. To experience our made-to-service risk free, you can add the option to return every item in your order for $25. If you keep your items, that $25 can be used as a credit against your next purchase. If you opt out of the $25 Returns Deposit, your order will still be eligible for store credit.'
    modalCheckbox = ''

    vex.dialog.buttons.NO.text = 'X'

    vex.dialog.open _.extend({
      message: '<h2 class="ReturnOption__content--headline font-sans-serif">' +
                 modalHeading +
               '</h2>' +
               '<div class="checkout-content font-sans-serif">' +
                 modalBody +
               '</div>' +
               modalCheckbox,
      className: 'vex vex-theme-plain checkout-modal vex-dialog-bottom vex-text ReturnModal',
      popup: true,
      afterOpen: @updateHtml,
      timeout: 0,
    }, opts)
    $('.vex-dialog-button-primary').text('continue')
    $('.vex-dialog-button-secondary').html('&times;')
