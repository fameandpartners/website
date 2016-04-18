$.fn.extend
  dynamicSelectable: ->
    $(@).each (i, el) ->
      new DynamicSelectable($(el))

class DynamicSelectable
  constructor: ($select) ->
    @init($select)

  init: ($select) ->
    @urlTemplate = '/fame_admin/product_colors/colors_options/:product_id'
    @$targetSelect = $($select.data('selectableTarget'))
    $select.on 'change', =>
      @clearTarget()
      url = @constructUrl($select.val())
      if url
        $.getJSON url, (data) =>
          $.each data['product_colors'], (index, el) =>
            @$targetSelect.append "<option value='#{el.id}'>#{el.name}</option>"
          @reinitializeTarget()
      else
        @reinitializeTarget()

  reinitializeTarget: ->
    @$targetSelect.trigger("chosen:updated")

  clearTarget: ->
    @$targetSelect.html('<option></option>')

  constructUrl: (id) ->
    if id && id != ''
      @urlTemplate.replace(/:product_id/, id)
