window.initBlogPostForm = ->
  toggleBlogPostCategoryVisibility()
  toggleBlogPostEventVisibility()
  $('#blog_post_post_type_id').on 'change', (e) ->
    toggleBlogPostCategoryVisibility()
    toggleBlogPostEventVisibility()
    false

window.toggleBlogPostCategoryVisibility = ->
  $type = $('#blog_post_post_type_id')
  if $type.val() == '1'
    $('#blog_post_category_id_field').hide()
  else
    $('#blog_post_category_id_field').show()

window.toggleBlogPostEventVisibility = ->
  $type = $('#blog_post_post_type_id')
  if $type.val() == '0'
    $('#blog_post_event_id_field').hide()
  else
    $('#blog_post_event_id_field').show()

window.initBlogPostTagsInput = ->
  $('#blog_post_tag_list').tagsInput({width:'auto'})
