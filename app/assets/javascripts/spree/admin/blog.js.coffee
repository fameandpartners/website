# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.add-photo-field').on 'click', (e) ->
    e.preventDefault()
    $('.photo-fields').append(
      $('<div />', class: 'photo-field').append(
        $('<input>', class: 'file-field', id: 'post_celebrity_photos', multiple: 'multiple', name: 'post[celebrity_photos_attributes][][photo]', type: 'file'),
        $('<a />', href: '#', text: 'Remove field', class: 'remove-field')
      )
    )

  $('.photo-fields').delegate '.remove-field', 'click', (e) ->
    e.preventDefault()
    $(@).parent().remove()
