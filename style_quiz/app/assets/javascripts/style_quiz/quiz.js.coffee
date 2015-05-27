# usage
# amd? require js?

window.StyleQuiz ||= {}
window.StyleQuiz.Quiz = class Quiz
  constructor: (opts = {}) ->
    @current = opts.current || 0
    @questions_data = opts.questions_data || []


    questions = _.map(opts.questions_data, (data) ->
      new StyleQuiz.Question(data)

    # start loading data
    #
    # activate current question
