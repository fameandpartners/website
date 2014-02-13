window.popups or= {}

window.popups.newsletterModalPopup = class newsletterModalPopup
  initialize: (scope) ->
    @scope = scope

  show: () =>
    $container = @scope.find('.modal-container')
    @scope.show()

    @updatePosition()

    @scope.find('.close-lightbox').bind 'click', () =>
      $.cookie('newsletter_mp', 'hide', { expires: 365, path: '/' })
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
    @scope.find('.modal-container').center()
