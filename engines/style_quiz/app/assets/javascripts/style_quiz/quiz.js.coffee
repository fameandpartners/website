# usage
# amd? require js?

window.StyleQuiz ||= {}
window.StyleQuiz.Quiz = class Quiz
  constructor: (opts = {}) ->
    @current        = opts.current || 0
    @questions_data = opts.questions_data || []
    @action         = opts.action
    @quiz_path      = opts.quiz_path
    @settings       = opts.settings
    @show_mode      = opts.show_mode # ['all', 'unfinished']
    @questions      = []

    settings = opts.settings

    user = new StyleQuiz.FbUser()
    window.user = user

    _.each(opts.questions_data, (data, index) ->
      # factory?
      klass_name = s.camelize("-#{ data.name}-question", false)
      question_params = _.extend({ user: user }, settings, data)
      if _.isFunction(StyleQuiz[klass_name])
        question = new StyleQuiz[klass_name](question_params)
      else
        question = new StyleQuiz.BaseQuestion(question_params)

      question.on('question:completed', @showNext)
      question.on('question:back',      @showPrevious)
      question.on('question:changed',   @storeIntermediateResults)

      @questions.push(question)
    , @)

    if @current > (@questions.length - 1)
      @current = @questions.length - 1

    @quizRemovePreload()
    @showCurrentQuestion()

  quizRemovePreload: ->
    $('.quiz-preloading').removeClass('quiz-preloading')

  showCurrentQuestion: () ->
    _.each(@questions, (question, index) ->
      if index == @current
        question.show()
    , @)
    @storeQuizStep()

  showNext: () =>
    unfinished_questions = @getUnfinishedQuestions()
    if unfinished_questions.length == 0
      @finish()
    else
      @current = unfinished_questions[0]
      @showCurrentQuestion()

  showPrevious: () =>
    if @current > 0
      @current = @current - 1
      @showCurrentQuestion()

  storeQuizStep: () ->
    if @current && @current > 0
      stepUrl = "#{ @quiz_path }?current=#{ @current }"
    else
      stepUrl =  @quiz_path

    window.history.pushState({ path: stepUrl }, '', stepUrl)

  storeIntermediateResults: () =>
    $.cookie('style_quiz:answers', JSON.stringify(@answers()), { expires: 7, path: @quiz_path })

  getUnfinishedQuestions: () ->
    switch @show_mode
      when 'all'
        finished = (element) -> element.isValid() && element.shown
      when 'unfinished'
        finished = (element) -> element.isValid()
      else
        finished = (element) -> element.isValid()

    result = []
    _.each(@questions, (element, index, list) ->
      result.push(index) unless finished(element)
    )
    result

  answers: () =>
    ids = []
    result = {}
    _.each(@questions, (question) ->
      value = question.value()
      ids = _.union(ids, value.ids)
      result = _.extend(result, value)
    )
    result.ids = ids
    result

  finish: () =>
    $.ajax(
      url: @action,
      type: 'PUT',
      dataType: 'json',
      data: { answers: @answers(), settings: @settings }
    ).success((data, status, xhr) =>
      nextPage = data.redirect_to || '/style-quiz/products'
      if window.parent
        window.parent.location = nextPage
      else
        window.location = nextPage
    ).error(() =>
      # error
    )
