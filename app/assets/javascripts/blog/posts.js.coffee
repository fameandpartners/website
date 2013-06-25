$ ->
  $('#tags_search_filter').on 'change', (e)->
    tag = $(e.target).val()
    window.location = "/search/tags/#{tag}"
    false

  $('#events_search_filter').on 'change', (e)->
    event = $(e.target).val()
    window.location = "/search/events/#{event}"
    false

  $('#search_by_query').on 'keyup', (e) ->
    if e.keyCode == 13
      term = $(e.target).val()
      if term != ""
        window.location = "/search?q=#{term}"
    false
