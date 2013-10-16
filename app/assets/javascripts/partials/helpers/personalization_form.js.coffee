window.helpers or= {}

window.helpers.addPersonalizationFormHandlers = (form) ->
  $form = $(form)

  is_required_presence = (scope) ->
    $scope = $(scope)

    names = _.uniq(_.map($scope.find(':input[data-required="true"]'), (item) -> $(item).attr('name')))

    _.all names, (name) ->
      $item = $(':input[name="' + name + '"]')

      if $item.is(':radio') && _.any($item, (item) -> $(item).is(':checked'))
        return $item.filter(':checked').val() isnt '' && $item.filter(':checked').is(':not(.default)')

      if $item.is(':input:not(:radio)')
        return $item.filter(':input:not(:radio)').val() isnt ''

      false

  tick_marker = (scope) ->
    $scope = $(scope)

    $link = $form.find('a[href="#' + $scope.attr('id') + '"]')

    $link.children().remove()

    if is_required_presence($scope)
      $marker = $('<div/>', class: 'done').append($('<i/>', class: 'icon icon-tickmark'))
      $link.append($marker)

  highlighter = (scope) ->
    $scope = $(scope)
    $scope.find('label:not(:has(:input:checked))').removeClass('active')
    $scope.find('label:has(:input:checked)').addClass('active')

  defaulter = (scope) ->
    $scope = $(scope)
    return unless $scope.has(':radio')

    unless $scope.is(':has(:radio:checked)')
      $scope.find(':radio.default').click()

  $form.find(':radio').change (event) ->
    highlighter($(event.target).parents('.tab-content'))

  $form.find(':radio.color.basic').change (event) ->
    $target = $(event.target)
    window.initProductImagesCarousel({color: $target.data('color')})

  $form.find(':input').change (event) ->
    $target = $(event.target)

    if $target.is(':radio')
      $select = $form.find('select[name="' + $target.attr('name') + '"]')

      $select.find('option').prop('selected', false)
      $select.trigger('liszt:updated')
    else if $target.is('select')
      $form.find(':radio[name="' + $target.attr('name') + '"]').prop('checked', false);
      highlighter($(event.target).parents('.tab-content'))

    tick_marker($target.parents('.tab-content'))

  $form.submit (event) ->
    if $form.find('select[name*="color_id"]').val() is ''
      $form.find('select[name*="color_id"]').prop('disabled', true)

    true

  $form.find('.tab-content').each (index, item)->
    highlighter(item)
    tick_marker(item)
    defaulter(item)

  $form.find('a:not(:has(.done))').first().click()
