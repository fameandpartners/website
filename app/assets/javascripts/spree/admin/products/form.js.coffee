$ ->
  return unless $('#new_product').length

  $('#new_product').delegate '.form-buttons [type=submit]', 'click', (e) ->
    return true unless $('.new-product-step').length

    unless $('[data-hook=new_product] .new-product-step:last').is(':visible')
      $('[data-hook=new_product] .new-product-step:not(:visible):first').show()
      e.preventDefault()
    true

