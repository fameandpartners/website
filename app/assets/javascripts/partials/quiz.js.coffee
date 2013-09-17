window.Quiz = {
  show: () ->
    $('.quiz-box').show()
    $('body').css 'overflow', 'hidden'
    $.getScript '/quiz'
    $('.quiz-overlay').one('click', Quiz.hide)
    $('#main-promo .slides').trigger('pause')

  hide: () ->
    $('.quiz-box').hide()
    $('body').css 'overflow', 'auto'
    $('#main-promo .slides').trigger('resume')

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
    $('.questions-count .inline.current').text(Quiz.currentStepNumber())

  bindCheckboxesAndRadios: () ->
    Quiz.steps().find(':checkbox, :radio').change (event) ->
      $question = $(event.target).parents('.question')
      $list = $question.find('ul')

      if ($list.hasClass('lips') || $list.hasClass('stars'))
        $item = $(event.target).parents('li')

        $item.prevAll().addClass('active')
        $item.nextAll().removeClass('active')
      else
        $question.find('li:not(:has(:input:checked))').removeClass('active')

      $question.find('li:has(:input:checked)').addClass('active')

  triggerEvents: (step) ->
    if Quiz.steps().index(step) is 2
      track.conversion('quiz_step1')
    else if Quiz.steps().index(step) is 3
      track.conversion('quiz_step2')


  _bindEvents: () ->
    $('.quiz-box').on 'click', (event) ->
      event.stopPropagation()

    $('.quiz-box .close-quiz').on 'click', () ->
      Quiz.hide()

    $(document).keyup (event) ->
      if event.which is 27
        $(document).off "keyup"
        $("#wrap").off "click"
        Quiz.hide()

    $("#wrap").on "click", () ->
      $("#wrap").off "click"
      $(document).off "keyup"
      Quiz.hide()

    Quiz.bindCheckboxesAndRadios()

    $('.quiz-box').find('.next a').click Quiz.nextStepEventHandler

    $('.quiz-box').find('.prev a').click Quiz.previousStepEventHandler
}

$ ->
  $('a.show-style-quiz').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    Quiz.show()

  if location.href.match(/[\?\&]osq\=1/)
    Quiz.show()
