// Create a link with class `fb-trackable` and `data-fb` attribute.
// <a class="fb-trackable" data-fb='123456789'>blah</a>
$(document).ready(function(){
  $('body').on('click', '.fb-trackable', function(e){

    var trackingID = $(e.target).data('fb');

    if (trackingID != undefined) {
      window._fbq = window._fbq || [];
      window._fbq.push(['track', trackingID, {'value':'0.00','currency':'AUD'}]);
    }
  });
});

