window.checkout ||= {}

window.checkout.address_step  = {
  init: (options = {}) ->
    checkout.address_step.initStatesChange()
    checkout.address_step.updateShippingFormVisibility()

    checkout.page.addAjaxCallback('loading', checkout.address_step.updateAddressFormVisibility)

    $(document).on('change',  '#order_use_billing', checkout.address_step.updateShippingFormVisibility)
    $(document).on('keyup',   'input', checkout.address_step.updateAddressFormVisibility)
    $(document).on('change',  'input', checkout.address_step.updateAddressFormVisibility)
    $(document).on('click',   'form.checkout-form input[type=submit]', checkout.page.onAjaxLoadingHandler)

  initStatesChange: (options = {}) ->
    $(options.field_id).val(options.field_value)
    update_state_func = () =>
      window.checkout.address_step.updateStatesVisibility(
        options.country_field_id, options.field_id, options.states_text_field_id
      )
    update_state_func()
    $(options.country_field_id).on('change', update_state_func)

  updateStatesVisibility: (country_field_id, states_field_id, states_text_field_id) ->
    country_id = $(country_field_id).val()
    $(states_field_id).find("option[data-country]").hide()
    if $(states_field_id).find("option[data-country=#{ country_id }]").length == 0
      # show input
      $(states_field_id).addClass('hidden').removeClass('required').prop('disabled', true)
      $(states_text_field_id).addClass('required').removeClass('hidden').prop('disabled', false)
    else
      $(states_text_field_id).addClass('hidden').removeClass('required').prop('disabled', true)
      # show available states
      $(states_field_id).addClass('required').removeClass('hidden').prop('disabled', false)
      $(states_field_id).find("option[data-country=#{ country_id }]").show()

      # if currently select option not available for selected country, reset
      if !country_id || $(states_field_id).find('option:selected').data('country') != parseInt(country_id)
        $(states_field_id).val('')

  updateShippingFormVisibility: () ->
    if $('#order_use_billing').is(':checked')
      $('[data-hook="shipping_inner"]').hide()
      $('[data-hook="shipping_inner"]').find(':input').prop('disabled', true)
    else
      $('[data-hook="shipping_inner"]').show()
      $('[data-hook="shipping_inner"]').find(':input').prop('disabled', false)

  updateAddressFormVisibility: (event) ->
    $('.grid-container.form-global.form-address').each((index, element) ->
      $container = $(element)
      firstname = $container.find('input[id$=address_attributes_firstname]').val()
      lastname = $container.find('input[id$=address_attributes_lastname]').val()
      email = $container.find('input[id$=address_attributes_email]').val()

      if (_.isEmpty(firstname) || _.isEmpty(lastname) || _.isEmpty(email))
        $container.find(".input.clearfix[data-require=user-credentials]").addClass('hide')
        $container.find(".submit-button input").attr('disabled', true)
      else
        $container.find(".input.clearfix[data-require=user-credentials]").removeClass('hide')
        $container.find(".submit-button input").removeAttr('disabled')
    )
    # if user filled first last email, show other elements
    # otherwise - hide&disable
}
