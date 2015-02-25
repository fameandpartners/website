// our code
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload

//= require libs/underscore-min
// spree have this by default
//= require libs/vex.combined.min.js

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
//= require js/alert.js
// require js/main.js
// require js/sg-scripts.js

//= require js/functions.js
//= require js/superslides.js
//= require functions_redesign.js

//= require helpers
//= require partials/helpers/site_version
//= require popups/style_quiz
//= require partials/product_collection.js
//= require partials/product_customisation.js
//= require partials/helpers/tracker.js.coffee
//= require partials/helpers/error_messages.js.coffee

// product details with related
//= require partials/product_details.js
//= require partials/inputs/new.js.coffee
//= require partials/helpers/product_images_slider.js.coffee
//= require partials/helpers/product_variants_selector.js.coffee

// shopping cart & bag & moodboard
//= require partials/helpers/shopping_cart
//= require partials/helpers/user_moodboard
//= require partials/shopping_bag
//= require templates/shopping_bag

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
