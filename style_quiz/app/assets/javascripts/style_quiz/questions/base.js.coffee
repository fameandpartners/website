# questions/steps for quiz
# common interface:
#   show 
#   hide
#   isValid
#
# events:
#   on: 'question:completed'
#   on: 'question:back'
#
window.StyleQuiz ||= {}
window.StyleQuiz.BaseQuestion = class BaseQuestion
  constructor: (opts = {}) ->
    @$container = $("##{ opts.name }-question")
    @$container.on('click', '*[data-action=next]', @submitQuestion)
    @$container.on('click', '*[data-action=previous]', @previousQuestion)
    @name = opts.name

  hide: () ->
    @$container.hide()

  show: () ->
    @$container.show()

  isValid: () ->
    # show error
    true

  submitQuestion: (e) =>
    e.preventDefault()
    @trigger('question:completed', @value())

  previousQuestion: (e) =>
    e.preventDefault()
    @trigger('question:back', @value())

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
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')

  value: () ->
    {
      hairColor: @$container.find('.hair.quiz-catalog .quiz-catalog-item.selected').data('value'),
      eyesColor: @$container.find('.eyes.quiz-catalog .quiz-catalog-item.selected').data('value')
    }

window.StyleQuiz.ColorDressesQuestion = class ColorDressesQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)

  toggleItemSelection: (e) ->
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')

  value: () ->
    {
      dressesColor: @$container.find('.quiz-catalog .quiz-catalog-item.selected')
    }

window.StyleQuiz.BodySizeShapeQuestion = class BodySizeShapeQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)
    @$container.on('click', '.size-picker .size', @toggleSizeSelection)

  toggleItemSelection: (e) ->
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')

  toggleSizeSelection: (e) ->
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.size-picker').find('.size').not(item).removeClass('selected')
    item.addClass('selected')

  value: () ->
    {
      bodyShape: @$container.find('.quiz-catalog .quiz-catalog-item.selected'),
      bodySize: @$container.find('.size-picker .size')
    }

window.StyleQuiz.EverydayStyleQuestion = class EverydayStyleQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .dress-style', @toggleItemSelection)

  toggleItemSelection: (e) ->
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.dress-style').not(item).removeClass('selected')
    item.addClass('selected')

  value: () ->
    {
      everyDayStyle: @$container.find('.quiz-catalog .dress-style.selected')
    }

window.StyleQuiz.DreamStyleQuestion = class DreamStyleQuestion extends window.StyleQuiz.EverydayStyleQuestion
window.StyleQuiz.RedCarpetStyleQuestion = class RedCarpetStyleQuestion extends window.StyleQuiz.EverydayStyleQuestion

window.StyleQuiz.FashionImportanceQuestion = class FashionImportanceQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.rank-cell', @setRankingHandler)

  setRankingHandler: (e) ->
    e.preventDefault()
    $(e.currentTarget).addClass('active').siblings().removeClass('active')

  value: (e) ->
    @$container.find('.rank-cell.active')

window.StyleQuiz.SexynessImportanceQuestion = class SexynessImportanceQuestion extends window.StyleQuiz.FashionImportanceQuestion

window.StyleQuiz.EventsFormQuestion = class EventsFormQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @events = (opts.values || [])

    @$container.on("click", '*[data-action=add-event]', @addEvent)
    @$container.on("click", '*[data-action=delete-event]', @deleteEvent)

  addEvent: (e) =>
    e.preventDefault()
    event = {
      name: @$container.find('input[name=name]').val(),
      type: @$container.find('input[name=type]').val(),
      date: @$container.find('input[name=date]').val()
    }
    @events.push(event)
    @$container.find('.events-list').append($("<div class='col-4'><div class='event-tag'><span>#{ event.date } - #{ event.name }</span><div class='icon-cross' data-action='delete-event'></div></div></div>"))

  deleteEvent: (e) =>
    e.preventDefault()
    item = $(e.currentTarget).closest('.col-4')
    index = @$container.find('.events-list .col-4').index(item)
    @events.splice(index, 1)
    item.remove()

  value: () ->
    @events
