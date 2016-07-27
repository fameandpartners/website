window.style or= {}

window.style.Quiz = class StyleQuiz
  container: null
  options: {}

  constructor: (options = {}) ->
    @options = options

    @container = $('.quiz-box')
    @containerInner = @container.find('.quiz-box-inner')
    @stepsBox = @container.find('.steps-box')

    @container.on('click', (e) -> e.stopPropagation())
    @container.find('.next a').click _.bind(@nextStepEventHandler, @)
    @container.find('.prev a').click _.bind(@previousStepEventHandler, @)

    # TODO: this is usef for capture email step. Shouldn't live with style quiz logic
    @container.find('.submit-quiz-capture-email').click _.bind(@nextStepEventHandler, @)

    @init()

  init: () ->
    _.delay(() ->
      window.style.init_fb_question(window.quiz)
    , 3000)

    _.each @container.find('.randomize'), (scope) ->
      $(scope).randomize()
    $frames = @container.find('.film-frame')
    $chart = @container.find('.chart')
    $frame = $frames.first()
    $frame.addClass('current')

    @bindCheckboxesAndRadios()

    @processImagesForStepsInSeries()

    @updateProgressBar()

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

  nextStepEventHandler: (event) ->
    event.preventDefault()

    if @isCurrentStepEmaiInput() and not @isEmailValid()
      $('.quiz-capture-email .error').removeClass('hidden')
      return

    if @isCurrentStepFinished()
      if @isNextStepExist()
        @goToNextStep()
      else
        @finish()

  previousStepEventHandler: (event) ->
    event.preventDefault()

    if @isPreviousStepExist()
      @goToPreviousStep()

  goToNextStep: () =>
    @goToStep(@nextStep())
    track.quizClickedNext(@currentQuestions().first().data('a-label'))

  goToPreviousStep: () =>
    @goToStep(@previousStep())

  goToStep: (step) =>
    $step = $(step)
    @processImagesForStepsInSeries()
    @container.find('.film').animate
      left: '-' + $step.position().left
    @steps().removeClass('current')
    $step.addClass('current')
    @containerInner.height($step.height())
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
    return if @isCurrentStepEmaiInput() then @isEmailValid() else @areCheckBoxesOrRadioButtonsFilled()

  isCurrentStepEmaiInput: () ->
    @currentStep().attr('id') is 'step-email'

  areCheckBoxesOrRadioButtonsFilled: () ->
    _.all @currentQuestions(), (question) ->
      $(question).is ':has(:checkbox:checked, :radio:checked)'

  isEmailValid: () ->
    value = $('input#quiz_user_email').val()
    re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    re.test(value)

  currentProgress: () ->
    ((100 / @stepsCount()) * @currentStepNumber()).toFixed()

  updateProgressBar: () ->
    @progressBar().animate
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
    $('.js-sexiness-carousel').slick("getSlick").refresh();
    return true

  loadImagesForStep: (step) ->
    $step = $(step)
    for image in $step.find('img')
      $image = $(image)
      if $image.attr('src') is '' && $image.data('src') isnt ''
        $image.attr('src', $image.data('src'))

  applyMasonryForStep: (step) =>
    $step = $(step)
    $step.find('.loader').show()

    $quizPhotos = $step.find('.photos')

    _quiz = @
    $step.find('.photos img').on 'load', () ->
      $image = $(this)
      $item = $image.parents('.item')
      $item.removeClass('unloaded').addClass('loaded')

      $unappended = $step.find('.item.loaded:not(.appended)')

      if $unappended.size() >= 7

        $step.find('.photos').addClass('appended')
        $step.find('.loader').hide()

        _quiz.applyScrollForStep($step)

  applyScrollForStep: (step) ->
    $scrollable = $(step).find('.scrollable')

  processImagesForStepsInSeries: () ->
    $steps = @stepsWithUnLoadedImage()
    index = 0

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
