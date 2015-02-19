// our code
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic

//= require libs/underscore-min

// styleguide code
//= require js/snap.svg-min.js
//= require js/modernizr.custom.js
//= require js/modernizr.js
//= require js/scrollspy.js
//= require js/dropdown.js
//= require js/sg-plugins.js
//= require js/svgicons-config.js
//= require js/svgicons.js
//= require js/jquery.skippr.min.js
//= require js/classie.js
//= require js/selectFx.js
//= require js/alert.js
//= require js/main.js
// require js/sg-scripts.js

//= require js/functions.js
//= require js/superslides.js
//= require functions_redesign.js

//= require partials/helpers/site_version
//= require popups/style_quiz
//= require partials/product_collection
//= require partials/helpers/tracker.js.coffee

// Profile/Account Settings
//= require partials/account_settings_page

jQuery(document).ready(function($){
  function add_script(src) {
    var script_element = document.createElement('script');
    script_element.setAttribute('src', src);
    script_element.setAttribute('type', 'text/javascript')
    document.head.appendChild(script_element);
    return true
  };

  add_script('/assets/js/sg-scripts.js');
  //add_script('/assets/js/main.js');


	$('#forgot-password').on('click', function(e) {
		e.preventDefault();
		email = $('#spree_user_email').val()
		window.location = $(this).attr('href') + '?email=' + email;
	});

})
