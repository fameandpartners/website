$ ->
  return unless $('#new_product').length

  $('#new_product').delegate '.form-buttons [type=submit]', 'click', (e) ->
    return true unless $('.new-product-step').length

    unless $('[data-hook=new_product] .new-product-step:last').is(':visible')
      $('[data-hook=new_product] .new-product-step:not(:visible):first').show()
      e.preventDefault()
    true


  $('#new_product').delegate '.customisation-types > li > label', 'click', ->
    $(this).closest('li').toggleClass('expanded')

  $('#new_product').delegate '.skip-customisation_', 'click', ->
    $wrapper = $(this).closest('#product_customisations')
    $wrapper.find(':checkbox').prop('checked', false)
    $wrapper.find('.customisation-types > li').removeClass('expanded')
    if $(this).closest('.new-product-step')[0] == $('[data-hook=new_product] .new-product-step:last')[0]
      $(this).closest('form').submit()
    false
