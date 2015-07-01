window.style_profile ||= {}
window.style_profile.EventsForm = class EventsForm
  constructor: (opts = {}) ->
    @$container = $(opts.container)

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

  addEvent: (event) ->
    $container = @$container

    $.ajax(
      url: '/style-quiz/user_profile/events',
      type: "POST"
      data: { event: event }
      dataType: "json"
    ).error(() =>
      # do nothing
    ).success((event, state, xhr) =>
      event_html = "<div data-id='#{ event.id }' class='col-sm-4 event'>" +
                     "<div class='form-tag'>" +
                       "<span>#{ event.date } - #{ event.name }</span>" +
                       "<div data-action='delete-event' class='icon-cross'>" +
                     "</div>" +
                   "</div>" +
                 "</div>"
      if $container.find(".events-list .event[data-id=#{ event.id }]").length > 0
        $container.find(".events-list .event[data-id=#{ event.id }]").replaceWith(event_html)
      else
        $container.find('.events-list').append(event_html)
    )

  deleteEventHandler: (e) =>
    e.preventDefault()
    event_id = $(e.currentTarget).closest('.event').data('id')
    return unless event_id

    $.ajax(
      url: "/style-quiz/user_profile/events/#{ event_id }",
      type: "DELETE"
      dataType: "json"
    ).success(() =>
      @$container.find(".events-list .event[data-id=#{ event_id }]").remove()
    ).error(() =>
      # do nothing
    )

  importFromFacebookHandler: (e) =>
    e.preventDefault()

    that = @
    dateFormat = that.$container.find('input[name=date]').datepicker('option', 'dateFormat')
    importFromFacebook = (events) ->
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

    @callForLoggedFacebookUser( () ->
      FB.api("/me/events", importFromFacebook)
    )

  callForLoggedFacebookUser: (callback) ->
    _callback = callback
    FB.getLoginStatus( (response) ->
      if (response && response.status == 'not_authorized')
        FB.login( (response) ->
          if (response.authResponse)
            _callback()
        , scope: 'email,user_birthday,user_events,user_friends',
          return_scopes: true
        )
      else
        _callback()
    )
