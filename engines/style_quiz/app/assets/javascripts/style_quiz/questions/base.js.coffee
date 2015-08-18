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
    @$container.find('.quiz-section-window').height($(window).height() - 110)
    @$container.on('click', '*[data-action=next]', @submitQuestion)
    @$container.on('click', '*[data-action=previous]', @previousQuestion)
    @name   = opts.name
    @user   = opts.user
    @shown  = false

    # console.log 'section', @$container

  hide: () ->
    @$container.hide()

  show: () ->
    $el = @$container
    $elTop = -$el.position().top + 'px'
    $el.find('.quiz-section-window').scrollTop(0)
    $('.quiz-sections-cutter').height($el.outerHeight())
    $('.quiz-sections-scroller').css
      'transform': 'translate3d(0,'+$elTop+', 0)'
      '-webkit-transform': 'translate3d(0,'+$elTop+', 0)'
    # $el.addClass('active').siblings().removeClass('active')
    @shown = true

  isValid: () ->
    true

  onValueChanged: (e) =>
    #@updateButtonsState()
    @hideValidationError()
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
    messageHtml = $("<div class='quiz-error'><div class='quiz-error-message'>#{ @validationError() }</div><div class='quiz-error-close icon-cross' /></div>").hide()
    if @$container.find('.quiz-error').length > 0
      @$container.find('.quiz-error').replaceWith(messageHtml)
    else
      @$container.prepend(messageHtml)
    @$container.find('.quiz-error').fadeIn()
    @$container.find('.quiz-error-close').on 'click', (e)->
      $(e.currentTarget).closest('.quiz-error').fadeOut()
    _.delay( () ->
      $('.quiz-error').fadeOut()
    , 3000)


  hideValidationError: () ->
    $('.quiz-error').fadeOut()


  validationError: () ->
    "Please, select at least one value"

  on: () -> @$container.on.apply(@$container, arguments)
  off: () -> @$container.off.apply(@$container, arguments)
  trigger: () -> @$container.trigger.apply(@$container, arguments)

window.StyleQuiz.SignupQuestion = class SignupQuestion extends window.StyleQuiz.BaseQuestion
  constructor: (opts = {}) ->
    super(opts)
    @$container.find('input').on('keyup', _.debounce(@onValueChanged, 100))
    @$container.on('click', '*[data-action=import-from-fb]', @importFromFacebookHandler)
 
    @$container.on("click", '*[data-action=login]', (e) ->
      e.preventDefault()
      popup = new popups.Login({})
      popup.open()
    )


    @$fullnameInput  = @$container.find("input[name=fullname]")
    @$birthdayInput = @$container.find("input[name=birthday]")
    @$emailInput     = @$container.find("input[name=email]")
    @$birthdayInput.datepicker({
      changeYear: true,
      yearRange: "1900:2015",
      maxDate: '-1Y',
      dateFormat: opts.dateFormat || "dd/mm/yy"
    })

  value: () ->
    {
      fullname:   @$fullnameInput.val(),
      birthday:  @$birthdayInput.val(),
      email:      @$emailInput.val()
    }

  isValid: () ->
    @fullnameValid() && @birthdayValid() && @emailValid()

  fullnameValid: () ->
    if _.isFunction(@$fullnameInput[0].checkValidity)
      @$fullnameInput[0].checkValidity()
    else
      !_.empty(@$fullnameInput.val())

  birthdayValid: () ->
    try
      dateFormat = @$birthdayInput.datepicker('option', 'dateFormat')
      return false if !@$birthdayInput.val()
      $.datepicker.parseDate(dateFormat, @$birthdayInput.val())
      return true
    catch
      return false

  emailValid: () ->
    if _.isFunction(@$emailInput[0].checkValidity)
      @$emailInput[0].checkValidity()
    else
      !_.empty(@$emailInput.val())

  validationError: () ->
    invalid_fields = []
    invalid_fields.push('Full name') unless @fullnameValid()
    invalid_fields.push('Date of Birth') unless @birthdayValid()
    invalid_fields.push('Email address') unless @emailValid()
    "Please provide #{ invalid_fields.join("/") }"

  importFromFacebookHandler: (e) =>
    e.preventDefault()

    @user.getUserProfile( (user_profile) =>
      @$fullnameInput.val(user_profile.name)
      @$emailInput.val(user_profile.email)
      @$birthdayInput.datepicker('setDate', new Date(user_profile.birthday))

      @onValueChanged()
    )

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

    $chart = @$container.find('.rank-box')
    chartWidth = 1200
    chartHeight = 400
    paddingSize = 30
    screenWidth = if $('body').width() > chartWidth then chartWidth else $('body').width()
    scale = Math.max(0.46, ((screenWidth - paddingSize) / chartWidth))
    $chart.css
      height: scale * chartHeight
      '-webkit-transform': 'scale('+scale+')'
      '-ms-transform': 'scale('+scale+')'
      '-o-transform': 'scale('+scale+')'
      'transform': 'scale('+scale+')'

  setRankingHandler: (e) =>
    e.preventDefault()
    $(e.currentTarget).addClass('selected').siblings().removeClass('selected')
    @onValueChanged()

  value: (e) ->
    { ids: @getSelectedAnswers(@$container.find('.rank-cell.selected')) }

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

    @$container.on("click", '*[data-action=add-event]', @addEventHandler)
    @$container.on("click", '*[data-action=delete-event]', @deleteEventHandler)
    @$container.on('click', '*[data-action=import-from-fb]', @importFromFacebookHandler)

    @$container.find('input[name=date]').datepicker({
      minDate: '+1D',
      showButtonPanel: true,
      dateFormat: opts.dateFormat || "dd/mm/yy"
    })

  addEventHandler: (e) =>
    e.preventDefault()
    event = {
      name:       @$container.find('input[name=name]').val(),
      event_type: @$container.find('input[name=event_type]').val(),
      date:       @$container.find('input[name=date]').val()
    }
    @addEvent(event)
    @resetForm()

  resetForm: () ->
    @$container.find('input[name=name]').val('')
    @$container.find('input[name=event_type]').val('')
    @$container.find('input[name=date]').datepicker('setDate', new Date())

  addEvent: (event) =>
    @events.push(event)
    @$container.find('.events-list').append($("<div class='col-4'><div class='event-tag'><span>#{ event.date } - #{ event.name }</span><div class='icon-cross' data-action='delete-event'></div></div></div>"))
    @onValueChanged()

  deleteEventHandler: (e) =>
    e.preventDefault()
    item = $(e.currentTarget).closest('.col-4')
    index = @$container.find('.events-list .col-4').index(item)
    @events.splice(index, 1)
    item.remove()
    @onValueChanged()

  value: () ->
    { events: @events }

  isValid: () ->
    @shown || @events.length > 0

  importFromFacebookHandler: (e) =>
    e.preventDefault()

    that = @
    dateFormat = that.$container.find('input[name=date]').datepicker('option', 'dateFormat')
    @user.getEvents((events) =>
      currentDate = new Date()
      _.each(events.data, (event, index) =>
        date = new Date(event.start_time || event.end_time)
        if date && date > currentDate
          that.addEvent({
            name: event.name,
            event_type: event.location,
            date: $.datepicker.formatDate(dateFormat, date)
          })
      )
      that.onValueChanged()
    )
