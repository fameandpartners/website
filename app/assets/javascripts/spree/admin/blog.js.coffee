# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.add-photo-field').on 'click', (e) ->
    e.preventDefault()
    $('.photo-fields').append(
      $('<div />', class: 'photo-field').append(
        $('<input>', class: 'text', id: 'post_celebrity_name', name: 'post[celebrity_photos_attributes][][celebrity_name]', size: '50', type: 'text'),
        $('<br>'),
        $('<input>', class: 'file-field', id: 'post_celebrity_photos', multiple: 'multiple', name: 'post[celebrity_photos_attributes][][photo]', type: 'file'),
        $('<a />', href: '#', text: 'Remove field', class: 'remove-field')
      )
    )

  $('.add-photo-field-red-carpet').on 'click', (e) ->
    e.preventDefault()
    $('.photo-fields').append(
      $('<div />', class: 'photo-field').append(
        $('<input>', class: 'text', id: 'red_carpet_event_celebrity_name', name: 'red_carpet_event[celebrity_photos_attributes][][celebrity_name]', size: '50', type: 'text'),
        $('<br>'),
        $('<input>', class: 'file-field', id: 'red_carpet_event_celebrity_photos', multiple: 'multiple', name: 'red_carpet_event[celebrity_photos_attributes][][photo]', type: 'file'),
        $('<a />', href: '#', text: 'Remove field', class: 'remove-field')
      )
    )


  $('.photo-fields').delegate '.remove-field', 'click', (e) ->
    e.preventDefault()
    $(@).parent().remove()

  $('.delete-resource').on 'click', ->
    dialog = confirm('Are you sure?')
    $(@).parents('tr').hide() if dialog
