# object to store moodboard data
window.helpers or= {}
window.helpers.UserMoodboard = class UserMoodboard
  constructor: (data = {}) ->
    @$eventBus = $({})
    @data = data

    @trigger =  delegateTo(@$eventBus, 'trigger')
    @on      =  delegateTo(@$eventBus, 'on')
    @one     =  delegateTo(@$eventBus, 'one')

  # data: { color_id, variant_id, product_id }
  addItem: (data = {}) ->
    $.ajax(
      url: urlWithSitePrefix("/wishlists_items")
      type: "POST"
      data: data
      dataType: "json"
    ).success(@updateData)

  updateData: (data) =>
    @data = data
    @trigger('changed')

  is_included: (data) ->
    console.log('is item included to wishlist')
