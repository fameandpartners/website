window.style or= {}

window.style.Quiz = class StyleQuiz
  container: null
  options: {}
  $tabletScreen = 768
  $phoneScreen = 500

  constructor: (options = {}) ->
    @options = options
    
    @masonryGutter = 10
    @masonryItemsInLine = switch
      when $(window).width() <= $tabletScreen && $(window).width() > $phoneScreen then 4
      when $(window).width() <= $phoneScreen then 2
      else 7

    @container = $('.quiz-box')
    @containerInner = @container.find('.quiz-box-inner')
    @stepsBox = @container.find('.steps-box')

    $(window).on('resize', _.throttle(@windowResizeHandler, 100))

    @container.on('click', (e) -> e.stopPropagation())
    @container.find('.next a').click _.bind(@nextStepEventHandler, @)
    @container.find('.prev a').click _.bind(@previousStepEventHandler, @)
    
    @init()

  windowResizeHandler: (e) =>
    e.preventDefault()
    #@updatePosition()

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
    @container.find('.film').css('width', $frame.width() * $frames.size())

    @steps().width(@stepsBox.width())
    @steps().find('.photos').find('.item').width((@stepsBox.width() / @masonryItemsInLine) - @masonryGutter)
    scale = Math.max(0.51, (@stepsBox.width() / $chart.width()))
    $chart.css
      height: $chart.height() * scale
      '-webkit-transform': 'scale('+scale+')'
      '-ms-transform': 'scale('+scale+')'
      '-o-transform': 'scale('+scale+')'
      'transform': 'scale('+scale+')'
    
    
    @bindCheckboxesAndRadios()

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
    # containerInner = @containerInner
    # setTimeout () ->
    #   @containerInner.height($frame.height())
    # , 1000
    

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

  goToNextStep: () =>
    @goToStep(@nextStep())
    track.quizClickedNext(@currentQuestions().first().data('a-label'))

  goToPreviousStep: () =>
    @goToStep(@previousStep())

  goToStep: (step) =>
    $step = $(step)
    @container.find('.film').animate
      left: '-' + $step.position().left
    @steps().removeClass('current')
    $step.addClass('current')
    @containerInner.height($step.height())
    if $step.find('.scrollable') && $(window).width() > $phoneScreen
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

  applyMasonryForStep: (step) =>
    $step = $(step)
    $step.find('.loader').show()
    @applyScrollForStep($step)

    $quizPhotos = $step.find('.photos')

    $quizPhotos.masonry
      gutter: @masonryGutter
      itemSelector: '.item.loaded'
      columnWidth: '.item'

    _quiz = @
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

        _quiz.applyScrollForStep($step)

  applyScrollForStep: (step) ->
    $scrollable = $(step).find('.scrollable')

    if $scrollable.data('jsp')
      $scrollable.data('jsp').reinitialise()
    else if $(window).width() > $phoneScreen
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
