$ ->
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

  google.maps.event.addDomListener(window, 'load', bindGoogleMapEvents);
  $('#blog_list_celebrity_photos').show()

