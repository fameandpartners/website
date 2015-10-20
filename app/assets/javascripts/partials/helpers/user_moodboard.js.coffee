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
    @dataLayerTrackEvent('addedToWishlist')

    if @contains(data)
      trigger('change')
      return

    $.ajax(
      url: urlWithSitePrefix("/wishlists_items")
      type: "POST"
      data: data
      dataType: "json"
    ).success(@updateData)

  updateData: (data = {}) =>
    @data = data
    @trigger('change')

  # { product_id:, color_id: }
  # - if color id not provided - search any product occurence
  contains: (data) ->
    if !data.color_id
      !!_.findWhere(@data.items, { product_id: data.product_id })
    else
      !!_.findWhere(@data.items, { product_id: data.product_id, color_id: data.color_id })

  dataLayerTrackEvent: (event_name) ->
    window.track.dataLayer.push({event: event_name})
