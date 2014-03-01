window.Quiz = {
  autoShow: false
  welcomeMessage: null
  redirectPath: null

  show: () ->
    $('.quiz-box').show()
    $('.quiz-box-inner').html('')
    Quiz.updatePosition()
    # $('body').css 'overflow', 'hidden'
    $.getScript('/quiz').
      success(() ->
        # execute 'after render'. can be refactor to list, for external api
        Quiz.showWelcomeMessage()
      )
    $('.quiz-overlay').one 'click', Quiz.hide
    $('.quiz-box .close-quiz').one 'click', Quiz.hide

    $(document).keyup (event) ->
      if event.which is 27
        $(document).off 'keyup'
        $('#wrap').off 'click'
        Quiz.hide()

    $('#wrap').on 'click', () ->
      $('#wrap').off 'click'
      $(document).off 'keyup'
      Quiz.hide()

    $('.quiz-box').on 'click', (event) ->
      event.stopPropagation()

    $(window).on 'resize', Quiz.updatePosition

  hide: () ->
    $('.quiz-box').hide()
    $('body').css 'overflow', 'auto'
    $(window).off 'resize', Quiz.updatePosition

  updatePosition: () ->
    $container = $('.quiz-wrapper-box')

    actual = $container.position().top
    expected = Math.max(20, $(window).scrollTop() + ($(window).height() - $container.outerHeight()) / 2)

    correction = if expected > actual then expected - actual else (actual - expected) * -1

    $container.css
      'margin-top': correction

  nextStepEventHandler: (event) ->
    event.preventDefault()

    if Quiz.isCurrentStepFinished()
      if Quiz.isNextStepExist()
        Quiz.goToNextStep()
      else
        Quiz.finish()

  previousStepEventHandler: (event) ->
    event.preventDefault()

    if Quiz.isPreviousStepExist()
      Quiz.goToPreviousStep()

  goToNextStep: () ->
    Quiz.goToStep(Quiz.nextStep())
    track.quizClickedNext(Quiz.currentQuestions().first().data('a-label'))

  goToPreviousStep: () ->
    Quiz.goToStep(Quiz.previousStep())

  goToStep: (step) ->
    $step = $(step)
    Quiz.scope().find('.film').animate
      left: '-' + $step.position().left
    Quiz.steps().removeClass('current')
    $step.addClass('current')

    if $step.find('.scrollable')
      if $step.find('.scrollable').data('jsp')
        $step.find('.scrollable').data('jsp').reinitialise()
      else
        $step.find('.scrollable').jScrollPane
          contentWidth: $step.width()
    Quiz.updateProgressBar()
    Quiz.updateCurrentStepNumber()
    Quiz.triggerEvents($step)

  finish: () ->
    Quiz.scope().find('form').submit()

  scope: () ->
    $('.quiz-box')

  steps: () ->
    Quiz.scope().find('.step')

  stepsCount: () ->
    Quiz.steps().size()

  progressBar: () ->
    Quiz.scope().find('.progress-bar')

  currentStep: () ->
    Quiz.steps().filter('.current').first()

  currentStepNumber: () ->
    Quiz.steps().index(Quiz.currentStep()) + 1

  currentQuestions: () ->
    Quiz.currentStep().find('.question:has(:checkbox, :radio)')

  nextStep: () ->
    Quiz.currentStep().next('.step')

  isNextStepExist: () ->
    Quiz.nextStep().size() isnt 0

  previousStep: () ->
    Quiz.currentStep().prev('.step')

  isPreviousStepExist: () ->
    Quiz.previousStep().size() isnt 0

  isCurrentStepFinished: () ->
    _.all Quiz.currentQuestions(), (question) ->
      $(question).is ':has(:checkbox:checked, :radio:checked)'

  currentProgress: () ->
    ((100 / Quiz.stepsCount()) * (Quiz.currentStepNumber() - 1)).toFixed()

  updateProgressBar: () ->
    Quiz.progressBar().find('.tooltip').text(Quiz.currentProgress() + '%')
    Quiz.progressBar().find('.filler').animate
      width: Quiz.currentProgress() + '%'

  updateCurrentStepNumber: () ->
    $('.questions-count .current').text(Quiz.currentStepNumber())

  bindCheckboxesAndRadios: () ->
    Quiz.steps().find(':checkbox, :radio').change (event) ->
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
    if Quiz.steps().index(step) is 2
      track.conversion('quiz_step1')
    else if Quiz.steps().index(step) is 3
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

    Quiz.applyScrollForStep($step)

    $step.find('.photos').masonry
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

        $unappended.addClass('appended')

        Quiz.applyScrollForStep($step)

  applyScrollForStep: (step) ->
    $scrollable = $(step).find('.scrollable')

    if $scrollable.data('jsp')
      $scrollable.data('jsp').reinitialise()
    else
      $scrollable.jScrollPane
        contentWidth: $(step).width() + 'px'

  processImagesForStepsInSeries: () ->
    $steps = Quiz.stepsWithUnLoadedImage()
    index = 0

    Quiz.applyMasonryForStep($steps[index])
    Quiz.loadImagesForStep($steps[index])

    setTimeout () ->
      Quiz.poller($steps, index)
    , 500

  poller: ($steps, index) ->
    unless $steps[index].is(':has(.item.unloaded)')
      index += 1

      if $steps[index]
        Quiz.applyMasonryForStep($steps[index])
        Quiz.loadImagesForStep($steps[index])

        setTimeout () ->
          Quiz.poller($steps, index)
        , 500
    else
      setTimeout () ->
        Quiz.poller($steps, index)
      , 500

  stepsWithUnLoadedImage: () ->
    $(step) for step in Quiz.steps() when $(step).is(':has(img[src=""][data-src!=""])')

  _bindEvents: () ->
    $('.quiz-box').on 'click', (event) ->
      event.stopPropagation()

    Quiz.bindCheckboxesAndRadios()

    $('.quiz-box').find('.next a').click Quiz.nextStepEventHandler

    $('.quiz-box').find('.prev a').click Quiz.previousStepEventHandler

    Quiz.processImagesForStepsInSeries()

    $('.quiz-box .photos-nav .up').on 'click', (event) ->
      $button = $(event.target)
      $scrollable = $button.parents('.photos-nav').prev('.scrollable')

      if $scrollable.data('jsp')
        $scrollable.data('jsp').scrollByY(-100)

    $('.quiz-box .photos-nav .down').on 'click', (event) ->
      $button = $(event.target)
      $scrollable = $button.parents('.photos-nav').prev('.scrollable')

      if $scrollable.data('jsp')
        $scrollable.data('jsp').scrollByY(100)

  showWelcomeMessage: () ->
    return if _.isEmpty(window.Quiz.welcomeMessage)
    $message_container = $('.quiz-box-inner .flash.message')
    $message_container.html(window.Quiz.welcomeMessage).removeClass('hide').show()
    _.delay(Quiz.hideWelcomeMessage, 10000)

  hideWelcomeMessage: () ->
    $message_container = $('.quiz-box-inner .flash.message')
    $message_container.fadeOut(() ->
      $message_container.addClass('hide').hide()
    )
}

$ ->
  $('a.show-style-quiz').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    Quiz.show()

  if location.href.match(/[\?\&]osq\=1/) || window.Quiz.autoShow
    Quiz.show()
