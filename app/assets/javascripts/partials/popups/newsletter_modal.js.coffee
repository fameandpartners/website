window.popups or= {}

window.popups.newsletterModalPopup = class newsletterModalPopup
  initialize: (scope) ->
    @scope = scope

  show: () =>
    $container = @scope.find('.modal-container')
    @scope.show()

    @updatePosition()

    @scope.find('.close-lightbox').bind 'click', () =>
      $.cookie('newsletter_mp', 'hide', { expires: 365 })
      @hide()

    @scope.find('.overlay').bind 'click', @hide
    $(document).bind 'keyup', @keyPressHandler

  hide: () =>
    @scope.hide()
    @scope.find('.close-lightbox').unbind 'click', @hide
    @scope.find('.overlay').unbind 'click', @hide
    $(document).unbind 'keyup', @keyPressHandler

  keyPressHandler: (event) =>
    @hide() if event.which is 27

  updatePosition: () =>
    $container = @scope.find('.modal-container')

    actual = $container.position().top
    expected = $(window).scrollTop() + ($(window).height() - $container.outerHeight()) / 2

    correction = if expected > actual then expected - actual else (actual - expected) * -1

    $container.css
      'margin-top': correction + 'px'