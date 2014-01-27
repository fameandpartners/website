window.Quiz = {
  show: () ->
    $('.quiz-box').show()
    Quiz.updatePosition()
    $('body').css 'overflow', 'hidden'
    $.getScript '/quiz'
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


  _bindEvents: () ->
    $('.quiz-box').on 'click', (event) ->
      event.stopPropagation()

    Quiz.bindCheckboxesAndRadios()

    $('.quiz-box').find('.next a').click Quiz.nextStepEventHandler

    $('.quiz-box').find('.prev a').click Quiz.previousStepEventHandler
    
    $('.quiz-box .photos img').on 'load', ->
      $('.quiz-box .photos').masonry
        gutter: 10
        columnWidth: '.item'
        itemSelector: '.item'

    $('.quiz-box .photos:first img').on 'load', ->
      $scrollable = $(this).parents('.scrollable')

      if $scrollable.data('jsp')
        $scrollable.data('jsp').reinitialise()
      else
        $scrollable.jScrollPane
          contentWidth: $(this).width() + 'px'

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
}

$ ->
  $('a.show-style-quiz').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    Quiz.show()

  if location.href.match(/[\?\&]osq\=1/)
    Quiz.show()


