# questions/steps for quiz
# common interface:
#   show 
#   hide
#   isValid
#
# events:
#   on: 'question:completed'
#   on: 'question:back'
#   on: 'question:changed'
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
    true

  onValueChanged: (e) =>
    @updateButtonsState()
    @trigger('question:changed', {})

  updateButtonsState: () =>
    if @isValid()
      @$container.find('*[data-action=next]').removeAttr('disabled').removeClass('disabled')
    else
      @$container.find('*[data-action=next]').attr('disabled', true).addClass('disabled')

  submitQuestion: (e) =>
    e.preventDefault()
    if !@isValid()
      @showValidationError()
      return

    @trigger('question:completed', @value())

  previousQuestion: (e) =>
    e.preventDefault()
    @trigger('question:back', @value())

  value: () ->
    {}

  getSelectedAnswers: (scope) ->
    _.map(scope, (item, i) ->
      $(item).data('value')
    )

  showValidationError: () ->
    console.log('[placeholder][showValidationError]: question data is invalid')

  on: () -> @$container.on.apply(@$container, arguments)
  off: () -> @$container.off.apply(@$container, arguments)
  trigger: () -> @$container.trigger.apply(@$container, arguments)

window.StyleQuiz.SignupQuestion = class SignupQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('input').on('keyup', _.debounce(@onValueChanged, 100))

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
      return false

window.StyleQuiz.ColorPaletteQuestion = class ColorPaletteQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)

    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)

  toggleItemSelection: (e) =>
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')
    @onValueChanged()

  isValid: () ->
    @$container.find('.quiz-catalog.hair .quiz-catalog-item.selected').length > 0 &&
      @$container.find('.quiz-catalog.eyes .quiz-catalog-item.selected').length > 0

  value: () ->
    {
      ids: @getSelectedAnswers(@$container.find('.quiz-catalog .quiz-catalog-item.selected'))
    }

window.StyleQuiz.ColorDressesQuestion = class ColorDressesQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)

  toggleItemSelection: (e) =>
    e.preventDefault()
    item = $(e.currentTarget)
    item.toggleClass('selected')
    @onValueChanged()

  isValid: () ->
    current_value = @value()
    current_value.ids && current_value.ids.length > 0

  value: () ->
    {
      ids: @getSelectedAnswers(@$container.find('.quiz-catalog .quiz-catalog-item.selected'))
    }

window.StyleQuiz.BodySizeShapeQuestion = class BodySizeShapeQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .quiz-catalog-item', @toggleItemSelection)
    @$container.on('click', '.size-picker .size', @toggleSizeSelection)

  toggleItemSelection: (e) =>
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.quiz-catalog').find('.quiz-catalog-item').not(item).removeClass('selected')
    item.addClass('selected')
    @onValueChanged()

  toggleSizeSelection: (e) =>
    e.preventDefault()
    item = $(e.currentTarget)
    $(e.currentTarget).closest('.size-picker').find('.size').not(item).removeClass('selected')
    item.addClass('selected')
    @onValueChanged()

  selectedShapes: () ->
    @getSelectedAnswers(@$container.find('.quiz-catalog .quiz-catalog-item.selected'))

  selectedSizes: () ->
    @getSelectedAnswers(@$container.find('.size-picker .size.selected'))

  isValid: () ->
    @selectedShapes().length > 0 && @selectedSizes() > 0

  value: () ->
    {
      ids: @selectedShapes().concat(@selectedSizes())
    }

window.StyleQuiz.EverydayStyleQuestion = class EverydayStyleQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.quiz-catalog .dress-style', @toggleItemSelection)

  toggleItemSelection: (e) =>
    e.preventDefault()
    $(e.currentTarget).toggleClass('selected')
    @onValueChanged()

  isValid: () ->
    current_value = @value()
    current_value.ids && current_value.ids.length > 0

  value: () ->
    {
      ids: @getSelectedAnswers(@$container.find('.quiz-catalog .dress-style.selected'))
    }

window.StyleQuiz.DreamStyleQuestion = class DreamStyleQuestion extends window.StyleQuiz.EverydayStyleQuestion
window.StyleQuiz.RedCarpetStyleQuestion = class RedCarpetStyleQuestion extends window.StyleQuiz.EverydayStyleQuestion

window.StyleQuiz.FashionImportanceQuestion = class FashionImportanceQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.on('click', '.rank-cell', @setRankingHandler)

  setRankingHandler: (e) =>
    e.preventDefault()
    $(e.currentTarget).addClass('active').siblings().removeClass('active')
    @onValueChanged()

  value: (e) ->
    { ids: @getSelectedAnswers(@$container.find('.rank-cell.active')) }

  isValid: () ->
    current_value = @value()
    current_value.ids && current_value.ids.length > 0

window.StyleQuiz.SexynessImportanceQuestion = class SexynessImportanceQuestion extends window.StyleQuiz.FashionImportanceQuestion

window.StyleQuiz.EventsFormQuestion = class EventsFormQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)

    @events = []
    @$container.find('.event').each((index, item) =>
      @events.push($(item).data())
    )

    @$container.on("click", '*[data-action=add-event]', @addEvent)
    @$container.on("click", '*[data-action=delete-event]', @deleteEvent)

    @$container.find('input[name=date]').datepicker({
      minDate: '+1D',
      showButtonPanel: true,
      dateFormat: 'yy-mm-dd'
    })

  addEvent: (e) =>
    e.preventDefault()
    event = {
      name:       @$container.find('input[name=name]').val(),
      event_type: @$container.find('input[name=event_type]').val(),
      date:       @$container.find('input[name=date]').val()
    }
    @events.push(event)
    @$container.find('.events-list').append($("<div class='col-4'><div class='event-tag'><span>#{ event.date } - #{ event.name }</span><div class='icon-cross' data-action='delete-event'></div></div></div>"))
    @onValueChanged()

  deleteEvent: (e) =>
    e.preventDefault()
    item = $(e.currentTarget).closest('.col-4')
    index = @$container.find('.events-list .col-4').index(item)
    @events.splice(index, 1)
    item.remove()
    @onValueChanged()

  value: () ->
    { events: @events }

  isValid: () ->
    return true
