window.helpers or= {}

window.helpers.addPersonalizationFormHandlers = (form) ->
  $form = $(form)

  is_required_presence = (scope) ->
    $scope = $(scope)

    names = _.map($scope.find(':input[data-required="true"]'), (item) -> $(item).attr('name'))

    _.all names, (name) ->
      $item = $(':input[name="' + name + '"]')

      if $item.is(':radio')
        _.any($item, (item) -> $(item).is(':checked'))
      else
        $item.val() != ''


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

  $form.find(':checkbox, :radio').change (event) ->
    highlighter($(event.target).parents('.tab-content'))

  $form.find(':input').change (event) ->
    tick_marker($(event.target).parents('.tab-content'))

  $form.find('.tab-content').each (index, item)->
    highlighter(item)
    tick_marker(item)

  $form.find('a:not(:has(.done))').first().click()

