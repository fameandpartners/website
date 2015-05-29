# questions/steps for quiz
# common interface:
#   show 
#   hide
#   isValid
#
# events:
#   on: 'question:completed'
#
window.StyleQuiz ||= {}
window.StyleQuiz.BaseQuestion = class BaseQuestion
  constructor: (opts = {}) ->
    @$container = $("##{ opts.name }-question")
    @$container.on('click', '*[data-action=next]', @submitQuestion)
    @name = opts.name

  hide: () ->
    @$container.hide()

  show: () ->
    @$container.show()

  isValid: () ->
    # show error
    true

  submitQuestion: () =>
    @trigger('question:completed', @value())

  value: () ->
    {}

  on: () -> @$container.on.apply(@$container, arguments)
  off: () -> @$container.off.apply(@$container, arguments)
  trigger: () -> @$container.trigger.apply(@$container, arguments)

window.StyleQuiz.SignupQuestion = class SignupQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)

  value: () ->
    {
      fullname:   @$container.find("input[name=fullname]").val(),
      birthdate:  @$container.find("input[name=birthdate]").val(),
      email:      @$container.find("input[name=email]").val()
    }

  isValid: () ->
    currentValue = @value()
    if currentValue.fullname && currentValue.birthdate && currentValue.email
      return true
    else
      # show validation messages?
      return false

window.StyleQuiz.ColorPaletteQuestion = class ColorPaletteQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)

    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)

  toggleItemSelection: (e) ->
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')

  value: () ->
    {
      hairColor: @$container.find('.hair.quiz-catalog .quiz-catalog-item.selected'),
      eyesColor: @$container.find('.hair.quiz-catalog .quiz-catalog-item.selected')
    }
