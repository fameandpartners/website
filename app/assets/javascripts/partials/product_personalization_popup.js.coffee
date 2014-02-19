#window.productPersonalizationPopup = {
#  scope: () ->
#    $('#personalize-dress-popup')
#
#  show: (additional_params) ->
#    $scope = productPersonalizationPopup.scope()
#    $container = $scope.find('.modal-container')
#
#    $scope.show()
#
#    for key, value of additional_params
#      $container.find('[name*="[' + key + ']"]').val(value)
#
#    track.customizationOpened(product_analytics_label)
#
#    actual = $container.position().top
#    expected = $(window).scrollTop() + ($(window).height() - $container.outerHeight()) / 2
#
#    correction = if expected > actual then expected - actual else (actual - expected) * -1
#
#    $container.css
#      'margin-top': correction + 'px'
#
#    $scope.find('.close-lightbox').bind 'click', productPersonalizationPopup.hide
#    $scope.find('.overlay').bind 'click', productPersonalizationPopup.hide
#    $(document).bind 'keyup', productPersonalizationPopup.keyPressHandler
#
#  hide: () ->
#    $scope = productPersonalizationPopup.scope()
#    $scope.hide()
#    $scope.find('.close-lightbox').bind 'click', productPersonalizationPopup.hide
#    $scope.find('.overlay').unbind 'click', productPersonalizationPopup.hide
#    $(document).unbind 'keyup', productPersonalizationPopup.keyPressHandler
#
#  success: (thanks, popup, variantId, cart_json) ->
#    window.shopping_cart.buildOnSuccessCallback(['item_added'], variantId, null)(cart_json)
#
#    $scope = productPersonalizationPopup.scope()
#    $scope.find('.modal-container').html(thanks)
#
#    track.customizationAddedToCart(product_analytics_label)
#
#    setTimeout () ->
#      productPersonalizationPopup.hide()
#      $scope.replaceWith(popup)
#    , 3000
#
#  fail: (html) ->
#    $scope = productPersonalizationPopup.scope()
#    $container = $scope.find('.modal-container')
#    $container.find('.form').html(html)
#
#  keyPressHandler: (event) ->
#    if event.which is 27
#      productPersonalizationPopup.hide()
#}
