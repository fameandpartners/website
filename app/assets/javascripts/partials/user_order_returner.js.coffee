window.page or= {}

window.page.UserOrderReturner = class UserOrderReturner

  constructor: (opts = {}) ->
    @$form   = $(opts.form)
    reasons = opts.reasons

    $('.return-reason-category-container').hide()
    $('.return-reason-container').hide()

    $('.return-action').change ->
      v = $(this).val();
      $p = $(this).parent()
      if v == "keep"
        $p.find('.return-reason-container').hide()
        $p.find('.return-reason-category-container').hide()
      else
        $p.find('.return-reason-category-container').show()

    $('.return-reason-category').change ->
      v = $(this).val().toLowerCase();
      v = v.charAt(0).toUpperCase() + v.slice(1);
      $p = $(this).parent()

      $select = $p.find('select.return-reason-select')
      opts = reasons[v] || []

      $select.find('option').remove()
      $.each(opts, (key, value) ->
        $select.append($('<option>', { value : value }).text(value));
      )

      $p.find('.return-reason-container').show()
      $p.find('.chosen-container.return-reason-select').show()

    $(@$form).on 'submit', (e) ->
      items = $('#order-return-form div.action')
      for item in items
        type = $('.return-action',$(item)).val()
        reason = $('.return-reason-category',$(item)).val()
        if type == 'Return' && reason == ''
          e.preventDefault()
          alert('You must select a reason for return')
          return
      # disable submit button after successfull click
      $(e.target).find('button').prop('disabled', true);
