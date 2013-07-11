$ ->
  $('#tags_search_filter').on 'change', (e)->
    tag = $(e.target).val()
    window.location = "/search/tags/#{tag}"
    false

  $('#events_search_filter').on 'change', (e)->
    event = $(e.target).val()
    window.location = "/red-carpet-events/#{event}"
    false

  $('#search_by_query').on 'keyup', (e) ->
    if e.keyCode == 13
      term = $(e.target).val()
      if term != ""
        window.location = "/search?q=#{term}"
    false


window.initInfiniteScroll = (url, posts_count, container, data) ->
  if posts_count > 10
      window.page = 1
      window.is_fetching = false
      data ?= {}
      $(window).scroll ->
        if (1 + window.page * 9) < posts_count and not window.is_fetching
          if $(window).scrollTop() + $(window).height() + 300 > $(document).height()
            window.is_fetching = true
            data.page = window.page + 1
            $.ajax
              url: url
              dataType: "script"
              data: data
