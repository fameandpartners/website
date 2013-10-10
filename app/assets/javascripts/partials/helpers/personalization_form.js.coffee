window.helpers or= {}

window.helpers.addPersonalizationFormHandlers = (form) ->
  $form = $(form)

  $form.find(':checkbox, :radio').change (event) ->
    $scope = $(event.target).parents('.tab-content')

    $scope.find('label:not(:has(:input:checked))').removeClass('active')

    $scope.find('label:has(:input:checked)').addClass('active')
