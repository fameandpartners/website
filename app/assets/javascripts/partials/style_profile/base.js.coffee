window.style_profile ||= {}

#= require partials/style_profile/events_form

#//= require partials/style_profile/recommendations
#//= require partials/style_profile/attributes

window.style_profile.init = () ->
  # init tabs
  $(document).on 'click.bs.tab.data-api', '.style-profile-tabs [data-toggle="tab"]', ->
    $('.style-profile-tabs').addClass('hidden-xs')

  $(document).on 'click', '.tab-pane-close', ->
    $('.style-profile-tabs').removeClass('hidden-xs').find('.active').removeClass('active')
    $(this).closest('.tab-pane').removeClass('active')

