window.paymentRequestModal = {
  scope: () ->
    $('#ask-parent-to-pay-modal')

  show: () ->
    $scope = paymentRequestModal.scope()
    $container = $scope.find('.modal-container')

    $scope.show()

    paymentRequestModal.updatePosition()

    if $container.find('.form').is(':empty')
      $.getScript '/payment_requests/new', paymentRequestModal.updatePosition

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
    $container = $scope.find('.modal-container')
    $container.find(':visible').hide()
    $container.append(html)
    setTimeout () ->
        $scope = paymentRequestModal.scope()
        $container = $scope.find('.modal-container')
        paymentRequestModal.hide()

        $container.find('.block-title, .aligncenter').remove();
        $container.find('.close-lightbox, .modal-title, .form').show()
        $container.find('.form').html('')

      , 3000

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
