$ ->
  $('.product-batch-upload').tabs()

  bindGoogleMapEvents = ->
    return if document.getElementById('gmap') is null
    currentLat = parseFloat($("#red_carpet_event_latitude").prop('value')) || 34.07711866840051
    currentLng = parseFloat($("#red_carpet_event_longitude").prop('value')) || -118.33030700683594
    mapOptions =
      zoom: 10
      disableDefaultUI: true
      center: new google.maps.LatLng(currentLat,currentLng)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById('gmap'), mapOptions);
    marker = null

    google.maps.event.addListener map, 'click', (event) ->
      $("#red_carpet_event_latitude").prop 'value', event.latLng.lat()
      $("#red_carpet_event_longitude").prop 'value', event.latLng.lng()
      geocoder = new google.maps.Geocoder()
      geocoder.geocode 'latLng': event.latLng, (results, status) ->
        if status == google.maps.GeocoderStatus.OK && results[1]
          $('#red_carpet_event_location').prop 'value', results[1].formatted_address

      marker.setMap(null) if marker
      marker = new google.maps.Marker position: event.latLng, map: map


  $('.blog-menu li').on 'click', ->
    $('.selected').removeClass 'selected'
    $(@).addClass 'selected'
    $('.blog-posts-list').hide()
    $("#blog_list_#{@.id}").show()

  if google?
    google.maps.event.addDomListener(window, 'load', bindGoogleMapEvents);
  $('#blog_list_celebrity_photos').show()

  $('.add_fields').off('click')
  $(document).delegate '.add_fields', 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()

    target = $(this).data("target")
    tag = $(target).data('childTag') || 'tr'
    selector = if $(target).data('includeInvisible') then tag else "#{tag}:visible"
    new_table_row = $("#{target} #{selector}:last").clone().show()
    new_id = new Date().getTime()
    currId = new_table_row.attr("id")
    if (typeof currId != 'undefined')
      new_table_row.attr("id", currId.replace(/\d+([^\d]*)$/, "#{new_id}$1"))
      if new_table_row.attr("id") == currId
        new_table_row.attr("id", new_table_row.attr("id") + '_' + new_id)

    new_table_row.find('.select2-container').remove()
    new_table_row.find("input, select").each ->
      el = $(this)
      el.val('')
      if (typeof el.attr("id") != 'undefined')
        el.attr("id", el.attr("id").replace(/\d+([^\d]*)$/, "#{new_id}$1"))
      if (typeof el.attr("name") != 'undefined')
        el.attr("name", el.attr("name").replace(/\d+([^\d]*)$/, "#{new_id}$1"))

    # When cloning a new row, set the href of all icons to be an empty "#"
    # This is so that clicking on them does not perform the actions for the
    # duplicated row
    new_table_row.find("a").each ->
      el = $(this)
      el.attr('href', '#')
    $(target).prepend(new_table_row)

    $(target).trigger('spree:field-added', new_table_row)

  $('body').off('click', 'a.remove_fields')
  $('body').on 'click', 'a.remove_fields', ->
    el = $(this)
    if el.data('confirm')
      return unless confirm(el.data('confirm'))
    el.siblings("input[type=hidden][name$='[_destroy]']").val("1")
    el.closest(".fields").hide()
    wrapperSelector = el.data('wrapperSelector') || 'tr'
    if el.attr("href") == '#'
      el.parents(wrapperSelector).fadeOut('hide', -> $(this.remove()))
    else if el.attr("href")
      $.ajax
        type: 'POST'
        url: el.attr("href")
        data:
          _method: 'delete'
          authenticity_token: AUTH_TOKEN
        success: (response) ->
          el.parents(wrapperSelector).fadeOut('hide', -> $(this.remove()))
        error: (response, textStatus, errorThrown) ->
          show_flash_error(response.responseText)

    false

  $('body').on 'click', '.export-as-csv', ->
    $form = $(this).closest('form')
    originalAction = $form.attr('action')
    params = $form.serializeArray()
    params.push(name: 'per_page', value: 1000)
    window.open(originalAction + '.csv?' + $.param(params), '_blank');
    false
