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
    modalBody = 'Since every Fame and Partners piece is tailor-made to fit your specific body and personal style, we do not accept returns. To experience our made-to-service risk free, you can add the option to return every item in your order for $19. If you keep your items, that $19 can be used as a credit against your next purchase.'
    modalCheckbox = ''

    vex.dialog.buttons.NO.text = 'X'

    vex.dialog.open _.extend({
      message: '<h2 class="ReturnOption__content--headline font-sans-serif">' +
                 modalHeading +
               '</h2>' +
               '<div class="checkout-content font-sans-serif">' +
                 modalBody +
               '</div>' +
               '<div class="ReturnOption__wrapper">' +
                 '<div class="ReturnOption__content col-xs-12">' +
                   '<div class="col-xs-1">' +
                     '<div class="Checkbox__wrapper">' +
                       '<input class="Checkbox js-returns-abc-option-trigger js-returns-trigger" type="checkbox" value="B" id="returns_option_b">' +
                       '<label for="returns_option_b" class="Checkbox__label"></label>' +
                     '</div>' +
                   '</div>' +
                 '<div class="col-xs-10">' +
                   '<p class="ReturnOption__copy text-right font-sans-serif">' +
                   'Add <strong>$19</strong>' +
                   ' for fully flexible returns' +
                   '</p>' +
                 '</div>' +
               '</div>',
      className: 'vex vex-theme-plain checkout-modal vex-dialog-bottom vex-text ReturnModal',
      popup: true,
      afterOpen: @updateHtml,
      timeout: 0,
    }, opts)

    elem = document.body
    event = document.createEvent('Event')
    event.initEvent('modal', true, true);
    elem.dispatchEvent(event);

    $('.vex-dialog-button-primary').text('continue')
    $('.vex-dialog-button-secondary').html('&times;')
