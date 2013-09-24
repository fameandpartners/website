window.paymentRequestModal = {
  scope: () ->
    $('#ask-parent-to-pay-modal')

  show: (variantId) ->
    $scope = paymentRequestModal.scope()
    $container = $scope.find('.modal-container')

    $scope.show()

    paymentRequestModal.updatePosition()

    url = '/payment_requests/new'

    if variantId?
      url = url + '?variant_id=' + variantId

    if $container.find('.form').is(':empty')
      $.getScript url, paymentRequestModal.updatePosition

    track.inviteToPayOpened()

    $scope.find('.close-lightbox').bind 'click', paymentRequestModal.hide
    $scope.find('.overlay').bind 'click', paymentRequestModal.hide
    $(document).bind 'keyup', paymentRequestModal.keyPressHandler

  hide: () ->
    $scope = paymentRequestModal.scope()
    $scope.hide()
    $scope.find('.close-lightbox').bind 'click', paymentRequestModal.hide
    $scope.find('.overlay').unbind 'click', paymentRequestModal.hide
    $(document).unbind 'keyup', paymentRequestModal.keyPressHandler

  success: (html) ->
    track.inviteToPaySent()
    $scope = paymentRequestModal.scope()
    $scope.find('.modal-container').html(html)
    $('#ask-parent-to-pay-button').remove()
    setTimeout paymentRequestModal.hide, 3000

  fail: (html) ->
    $scope = paymentRequestModal.scope()
    $container = $scope.find('.modal-container')
    $container.find('.form').html(html)

  keyPressHandler: (event) ->
    if event.which is 27
      paymentRequestModal.hide()

  updatePosition: () ->
    $scope = paymentRequestModal.scope()
    $container = $scope.find('.modal-container')

    actual = $container.position().top
    expected = $(window).scrollTop() + ($(window).height() - $container.outerHeight()) / 2

    correction = if expected > actual then expected - actual else (actual - expected) * -1

    $container.css
      'margin-top': correction + 'px'
}
