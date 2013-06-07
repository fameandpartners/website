$ ->
  bindGoogleMapEvents = ->
    el = $('#event_postion')
    currentLat = parseFloat(el.data('lat'))
    currentLng = parseFloat(el.data('lng'))
    mapOptions =
      zoom: 10
      disableDefaultUI: true
      center: new google.maps.LatLng(currentLat,currentLng)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById('gmap-user'), mapOptions);

  google.maps.event.addDomListener(window, 'load', bindGoogleMapEvents);
  console.log "sdf"

