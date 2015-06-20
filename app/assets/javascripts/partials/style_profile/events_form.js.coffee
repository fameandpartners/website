window.style_profile ||= {}
window.style_profile.EventsForm = class EventsForm
  constructor: (opts = {}) ->
    @$container = $(opts.container)

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

  deleteEvent: (e) =>
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
