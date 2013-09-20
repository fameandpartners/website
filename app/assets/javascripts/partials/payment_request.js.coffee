window.paymentRequestModal = {
  scope: () ->
    $('#ask-parent-to-pay-modal')

  show: () ->
    $scope = paymentRequestModal.scope()
    $container = $scope.find('.modal-container')

    expected = $(window).scrollTop() + 60
    $scope.show()
    actual = $container.position().top
    correction = if expected > actual then expected - actual else (actual - expected) * -1
    $container.css
      'margin-top': correction + 'px'

    $.getScript '/payment_requests/new' if $container.find('.form').is(':empty')

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
}
