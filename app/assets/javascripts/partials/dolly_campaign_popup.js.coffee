window.dollyCampaignModal = {
  scope: () ->
    $('.modal.campaign-dolly')

  show: () ->
    $scope = dollyCampaignModal.scope()
    $container = $scope.find('.modal-container')

    $scope.show()

    dollyCampaignModal.updatePosition()

    $scope.find('.close-lightbox').bind 'click', () ->
      $.cookie('nmc_dolly', 'hide', { expires: 365, path: '/' })
      dollyCampaignModal.hide()
    $scope.find('.overlay').bind 'click', dollyCampaignModal.hide
    $(document).bind 'keyup', dollyCampaignModal.keyPressHandler

  hide: () ->
    $scope = dollyCampaignModal.scope()
    $scope.hide()
    $scope.find('.close-lightbox').unbind 'click', dollyCampaignModal.hide
    $scope.find('.overlay').unbind 'click', dollyCampaignModal.hide
    $(document).unbind 'keyup', dollyCampaignModal.keyPressHandler

  keyPressHandler: (event) ->
    if event.which is 27
      dollyCampaignModal.hide()

  updatePosition: () ->
    $scope = dollyCampaignModal.scope()
    $container = $scope.find('.modal-container')

    actual = $container.position().top
    expected = $(window).scrollTop() + ($(window).height() - $container.outerHeight()) / 2

    correction = if expected > actual then expected - actual else (actual - expected) * -1

    $container.css
      'margin-top': correction + 'px'
}

$(document).ready () ->
  url = $.url(location.href)

  if url.param('nm') is 'true' && url.param('nmc') is 'dolly' && $.cookie('nmc_dolly') isnt 'hide'
    dollyCampaignModal.show()
