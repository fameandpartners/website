# TODO - 2015.11.23 - This existing functionality only allows for a single moodboard.
# New Moodboards will require that the POST includes the moodboard ID.
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

  itemCount: ->
    @data.item_count

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


# A shameless copypasta from the UserMoodboard.
# TODO - Refactor into vanillajs
window.helpers.UserMoodboardStore = class UserMoodboardStore
  constructor: (moodboards = {}) ->
    # $EventBus is totally cargo culted from the previous UserMoodboard class.
    @$eventBus = $({})

    @trigger =  delegateTo(@$eventBus, 'trigger')
    @on      =  delegateTo(@$eventBus, 'on')
    @one     =  delegateTo(@$eventBus, 'one')

    @updateMoodboards(moodboards)

  addItem: (item = {}) ->
    @dataLayerTrackEvent()

    if @hasItem(item)
      trigger('change')
      return

    moodboard = @getMoodboard(item.moodboard_id)#(@moodboards.moodboards.filter (m) -> m.id is item.moodboard_id)[0]

    $.ajax(
      url: moodboard.path,
      type: "POST",
      data: item,
      dataType: "json",
    ).success(@updateMoodboards)


  hasItem: (item = {}) ->
    moodboard = @getMoodboard(item.moodboard_id)

    if !item.color_id
      !!_.findWhere(moodboard.items, { product_id: item.product_id })
    else
      !!_.findWhere(moodboard.items, { product_id: item.product_id, color_id: item.color_id })

  getMoodboard: (moodboard_id) ->
    (@moodboards.moodboards.filter (m) -> m.id is moodboard_id)[0]

  updateMoodboards: (moodboards = {}) =>
    @moodboards = moodboards
    @trigger('change')

  default: ->
    @moodboards.default

  dataLayerTrackEvent: ->
    window.track.dataLayer.push({event: 'addedToWishlist'})
