# usage
# amd? require js?

window.StyleQuiz ||= {}
window.StyleQuiz.Quiz = class Quiz
  constructor: (opts = {}) ->
    @current = opts.current || 0
    @questions_data = opts.questions_data || []
    @action = opts.action

    settings = opts.settings
    @questions = []
    _.each(opts.questions_data, (data, index) ->
      # factory?
      klass_name = s.camelize("-#{ data.name}-question", false)
      if _.isFunction(StyleQuiz[klass_name])
        question = new StyleQuiz[klass_name](_.extend({}, settings, data))
      else
        question = new StyleQuiz.BaseQuestion(_.extend({}, settings, data))

      question.on('question:completed', @showNext)
      question.on('question:back', @showPrevious)
      @questions.push(question)
    , @)

    if @current > (@questions.length - 1)
      @current = @questions.length - 1

    @showCurrentQuestion()

  showCurrentQuestion: () ->
    _.each(@questions, (question, index) ->
      if index == @current
        question.show()
      else
        question.hide()
    , @)

  showNext: () =>
    if @questions[@current]
      if @current < ( @questions.length - 1 )
        @current = @current + 1
        @showCurrentQuestion()
      else
        @finish()
    else
      # invalid case, some unknown positon
      false

  showPrevious: () =>
    if @current > 0
      @current = @current - 1
      @showCurrentQuestion()

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
      data: { answers: @answers() }
    ).success((data, status, xhr) =>
      nextPage = data.redirect_to || '/style-quiz/products'
      if window.parent
        window.parent.location = nextPage
      else
        window.location = nextPage
      console.log('success', arguments)
    ).error(() =>
      console.log('error', arguments)
    )
