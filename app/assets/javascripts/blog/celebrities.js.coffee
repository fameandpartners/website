$ ->
  $('#celebrity_show_page').on 'change', (e)->
    value = $(e.target).val()
    window.location = value
    false
