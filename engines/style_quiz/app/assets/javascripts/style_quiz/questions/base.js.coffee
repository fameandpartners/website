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
    $('html, body').animate({ scrollTop: 0 }, 'fast')
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
    messageHtml = $("<div class='error-message'>#{ @validationError() }</div>").hide()
    if @$container.find('.error-message').length > 0
      @$container.find('.error-message').replaceWith(messageHtml)
    else
      @$container.prepend(messageHtml)
    @$container.find('.error-message').fadeIn()
    _.delay( () ->
      $('.error-message').fadeOut()
    , 5000)

  hideValidationError: () ->

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
    if _.isFunction(@$birthdayInput[0].checkValidity)
      @$birthdayInput[0].checkValidity()
    else
      !_.empty(@$birthdayInput.val())

  emailValid: () ->
    if _.isFunction(@$emailInput[0].checkValidity)
      @$emailInput[0].checkValidity()
    else
      !_.empty(@$emailInput.val())

  validationError: () ->
    "Please provide Full name/Date of Birth/Email address"

  importFromFacebookHandler: (e) =>
    e.preventDefault()

    importFromFacebook = (user_profile) =>
      @$fullnameInput.val(user_profile.name)
      @$emailInput.val(user_profile.email)

      @$birthdayInput.datepicker('setDate', new Date(user_profile.birthday))

      # set datepicker to fb format & restore previous settings
      # datepicker convert automatically
      #old_format = @$birthdayInput.datepicker('option', 'dateFormat')
      #@$birthdayInput.datepicker('option', 'dateFormat', 'mm/dd/yy')
      #@$birthdayInput.datepicker('setDate', user_profile.birthday)
      #@$birthdayInput.datepicker('option', 'dateFormat', old_format)

    requestFbProfile = () ->
      FB.api("/me", importFromFacebook)

    FB.getLoginStatus( (response) ->
      if (response && response.status == 'not_authorized')
        FB.login( (response) ->
          if (response.authResponse)
            requestFbProfile()
        , scope: 'email,user_birthday,user_events',
          return_scopes: true
        )
      else
        requestFbProfile()
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
    return true

  importFromFacebookHandler: (e) =>
    e.preventDefault()

    that = @
    dateFormat = that.$container.find('input[name=date]').datepicker('option', 'dateFormat')
    importFromFacebook = (events) ->
      _.each(events.data, (event, index) =>
        date = new Date(event.start_time || event.end_time)
        that.addEvent({
          name: event.name,
          event_type: event.location,
          date: $.datepicker.formatDate(dateFormat, date)
        })
      )

    requestFbProfile = () ->
      FB.api("/me/events", importFromFacebook)

    FB.getLoginStatus( (response) ->
      if (response && response.status == 'not_authorized')
        FB.login( (response) ->
          if (response.authResponse)
            requestFbProfile()
        , scope: 'email,user_birthday,user_events',
          return_scopes: true
        )
      else
        requestFbProfile()
    )
