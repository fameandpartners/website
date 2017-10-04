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

window.page.ReturnsOptimizelyModal = class ReturnsOptimizelyModal extends CheckoutModal
  constructor: (opts = '') ->
    if (opts == 'A')
      modalHeading = 'Don’t miss out on 10% savings!'
      modalBody = 'The cost of returns is factored into the price of any online purchase. If you opt out of returning your made-to-order garment, we save money–and we want to pass that 10% savings onto you. If you do choose to opt out of returns and save 10%, all items will still be eligible for exchange.'
      modalCheckbox = '<div class="row js-returns-abc-option-A">' +
                        $('.js-returns-abc-option-A').html() +
                      '</div>'
    else if (opts == 'B')
      modalHeading = 'Don’t miss out on flexible returns.'
      modalBody = 'Since every Fame and Partners piece is tailor-made to fit your specific body and personal style, we only offer exchange or store credit. To experience our made-to-service risk free, you can add the option to return every item in your order for $25. If you keep your items, that $25 can be used as a credit against your next purchase. If you opt out of the $25 Returns Deposit, your order will still be eligible for exchange or store credit.'
      modalCheckbox = '<div class="row js-returns-abc-option-B">' +
                        $('.js-returns-abc-option-B').html() +
                      '</div>'
    else if (opts == 'A-info')
      modalHeading = 'Want to save 10%?'
      modalBody = 'The cost of returns is factored into the price of any online purchase. If you opt out of returning your made-to-order garment, we save money–and we want to pass that 10%  savings onto you. If you do choose to opt out of returns and save 10%, all items will still be eligible for exchange.'
      modalCheckbox = ''
    else if (opts == 'B-info')
      modalHeading = 'Want fully flexible returns?'
      modalBody = 'Since every Fame and Partners piece is tailor-made to fit your specific body and personal style, we only offer exchange or store credit. To experience our made-to-service risk free, you can add the option to return every item in your order for $25. If you keep your items, that $25 can be used as a credit against your next purchase. If you opt out of the $25 Returns Deposit, your order will still be eligible for exchange or store credit.'
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
