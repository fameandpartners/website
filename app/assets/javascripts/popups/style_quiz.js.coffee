#= require templates/quiz_popup.jst.eco
#= require libs/masonry.pkgd
#= require libs/jquery.jscrollpane.js

window.popups or= {}
window.page or= {}

window.popups.StyleQuizPopup = class StyleQuizPopup
  container: null

  constructor: () ->
    $('body').after(JST['templates/quiz_popup']())
    @container = $('.quiz-box')
    @container

  show: () ->
    @container.show()
    @container.find('.quiz-box-inner').html('')

    @updatePosition()

    $.getScript(urlWithSitePrefix('/quiz')).
      success(() =>
        @onLoad()
        @showWelcomeMessage()
      )

    @container.find('.quiz-overlay').one('click', @hide)
    @container.find('.cloze-quiz').one('click', @hide)
    @onShow()

  is_visible: () ->
    @container.is(':visible')

  hide: () ->
    @container.hide().remove()
    @container = null
    @onHide()
    # TODO trigger event 'on closed' here, please
    $.cookie('quiz_shown', 'true', { expires: 3650, path: '/' })

  updatePosition: () =>
    $wrapper = @container.find('.quiz-wrapper-box')

    actual = $wrapper.position().top
    expected = Math.max(20, $(window).scrollTop() + ($(window).height() - $wrapper.outerHeight()) / 2)
    correction = if expected > actual then expected - actual else (actual - expected) * -1

    $wrapper.css
      'margin-top': correction

  onShow: () ->
    $(document).keyup (event) =>
      if event.which is 27
        @hide()
    @container.on('click', (e) -> event.stopPropagation())
    $('#wrap').on 'click', @hide
    $(window).on 'resize', @updatePosition

  onLoad: () ->
    _.each @container.find('.randomize'), (scope) ->
      $(scope).randomize()
    $frames = @container.find('.film-frame')
    $frame = $frames.first()
    $frame.addClass('current')
    @container.find('.film').css('width', $frame.width() * $frames.size())

    @bindCheckboxesAndRadios()

    @container.find('.next a').click @nextStepEventHandler
    @container.find('.prev a').click @previousStepEventHandler

    @processImagesForStepsInSeries()

    @container.find('.photos-nav .up').on 'click', (event) ->
      $button = $(event.target)
      $scrollable = $button.parents('.photos-nav').prev('.scrollable')

      if $scrollable.data('jsp')
        $scrollable.data('jsp').scrollByY(-100)

    @container.find('.photos-nav .down').on 'click', (event) ->
      $button = $(event.target)
      $scrollable = $button.parents('.photos-nav').prev('.scrollable')

      if $scrollable.data('jsp')
        $scrollable.data('jsp').scrollByY(100)

  onHide: () ->
    #$('#wrap').off 'click'
    $(document).off 'keyup'
    $(window).off 'resize', @updatePosition

  nextStepEventHandler: (event) ->
    event.preventDefault()

    if @isCurrentStepFinished()
      if @isNextStepExist()
        @goToNextStep()
      else
        @finish()

  previousStepEventHandler: (event) ->
    event.preventDefault()

    if @isPreviousStepExist()
      @goToPreviousStep()

  goToNextStep: () ->
    @goToStep(@nextStep())
    # TODO
    track.quizClickedNext(@currentQuestions().first().data('a-label'))

  goToPreviousStep: () ->
    @goToStep(@previousStep())

  goToStep: (step) ->
    $step = $(step)
    @container.find('.film').animate
      left: '-' + $step.position().left
    @steps().removeClass('current')
    $step.addClass('current')

    if $step.find('.scrollable')
      if $step.find('.scrollable').data('jsp')
        $step.find('.scrollable').data('jsp').reinitialise()
      else
        $step.find('.scrollable').jScrollPane
          contentWidth: $step.width()
    @updateProgressBar()
    @updateCurrentStepNumber()
    @triggerEvents($step)

  finish: () ->
    @container.find('form').submit()

  steps: () ->
    @container.find('.step')

  stepsCount: () ->
    @steps().size()

  progressBar: () ->
    @container.find('.progress-bar')

  currentStep: () ->
    @steps().filter('.current').first()

  currentStepNumber: () ->
    @steps().index(@currentStep()) + 1

  currentQuestions: () ->
    @currentStep().find('.question:has(:checkbox, :radio)')

  nextStep: () ->
    @currentStep().next('.step')

  isNextStepExist: () ->
    @nextStep().size() isnt 0

  previousStep: () ->
    @currentStep().prev('.step')

  isPreviousStepExist: () ->
    @previousStep().size() isnt 0

  isCurrentStepFinished: () ->
    _.all @currentQuestions(), (question) ->
      $(question).is ':has(:checkbox:checked, :radio:checked)'

  currentProgress: () ->
    ((100 / @stepsCount()) * (@currentStepNumber() - 1)).toFixed()

  updateProgressBar: () ->
    @progressBar().find('.tooltip').text(@currentProgress() + '%')
    @progressBar().find('.filler').animate
      width: @currentProgress() + '%'

  updateCurrentStepNumber: () ->
    @container.find('.questions-count .current').text(@currentStepNumber())

  bindCheckboxesAndRadios: () ->
    @steps().find(':checkbox, :radio').change (event) ->
      $question = $(event.target).parents('.question')
      $list = $question.find('.items-box')

      if ($list.hasClass('lips') || $list.hasClass('stars'))
        $item = $(event.target).parents('.item')

        $item.prevAll().addClass('active')
        $item.nextAll().removeClass('active')
      else
        $question.find('.item:not(:has(:input:checked))').removeClass('active')

      $question.find('.item:has(:input:checked)').addClass('active')

  triggerEvents: (step) ->
    if @steps().index(step) is 2
      track.conversion('quiz_step1')
    else if @steps().index(step) is 3
      track.conversion('quiz_step2')

  loadImagesForStep: (step) ->
    $step = $(step)
    for image in $step.find('img')
      $image = $(image)
      if $image.attr('src') is '' && $image.data('src') isnt ''
        $image.css
          'position': 'absolute'
          'left': '-4500px'
        $image.attr('src', $image.data('src'))

  applyMasonryForStep: (step) ->
    $step = $(step)
    $step.find('.loader').show()
    @applyScrollForStep($step)

    $quizPhotos = $step.find('.photos')

    $quizPhotos.masonry
      gutter: 10
      columnWidth: '.item'
      itemSelector: '.item.loaded'

    $step.find('.photos img').on 'load', () ->
      $image = $(this)
      $item = $image.parents('.item')
      $item.removeClass('unloaded').addClass('loaded')

      $unappended = $step.find('.item.loaded:not(.appended)')

      if $unappended.size() >= 7
        $unappended.find('img').css
          'position': ''
          'left': ''

        $step.find('.photos').masonry 'appended', $unappended
        $step.find('.loader').hide()
        $unappended.addClass('appended')

        @applyScrollForStep($step)

  applyScrollForStep: (step) ->
    $scrollable = $(step).find('.scrollable')

    if $scrollable.data('jsp')
      $scrollable.data('jsp').reinitialise()
    else
      $scrollable.jScrollPane
        contentWidth: $(step).width() + 'px'

  processImagesForStepsInSeries: () ->
    $steps = @stepsWithUnLoadedImage()
    index = 0

    @applyMasonryForStep($steps[index])
    @loadImagesForStep($steps[index])

    setTimeout () =>
      @poller($steps, index)
    , 500

  poller: ($steps, index) ->
    unless ($steps[index] && $steps[index].is(':has(.item.unloaded)'))
      index += 1

      if $steps[index]
        @applyMasonryForStep($steps[index])
        @loadImagesForStep($steps[index])

        setTimeout () =>
          @poller($steps, index)
        , 500
    else
      setTimeout () =>
        @poller($steps, index)
      , 500

  stepsWithUnLoadedImage: () ->
    $(step) for step in @steps() when $(step).is(':has(img[src=""][data-src!=""])')

  showWelcomeMessage: () ->
    return if _.isEmpty(@welcomeMessage)
    $message_container = @container.find('.quiz-box-inner .flash.message')
    $message_container.html(@welcomeMessage).removeClass('hide').show()
    _.delay(@hideWelcomeMessage, 10000)

  hideWelcomeMessage: () ->
    $message_container = @container.find('.quiz-box-inner .flash.message')
    $message_container.fadeOut(() ->
      $message_container.addClass('hide').hide()
    )

    
# this method supports following
# enableStyleQuizPopup
#  - add 'on click' handler for required
#  - show immediately
#  - show after delay
window.page.enableStyleQuizPopup = (selector, options) ->
  options ||= {}
  _popup = null

  showPopup = () =>
    _popup ||= new popups.StyleQuizPopup()
    _popup.show()

  $(selector).on('click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    showPopup()
  )

  if options.autoShow
    showPopup()
  else if options.delayShow
    _.delay(showPopup, 20000)
