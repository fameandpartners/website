// our code
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload

//= require libs/underscore-min
// spree have this by default
//= require libs/snap.svg-min.js
//= require libs/vex.combined.min.js
//= require libs/jquery.cookie
//= require libs/jquery.chosen.min
//= require libs/soundcloud/sc-player
//= require libs/jquery.hoverable.js
//= require libs/superslides.js
//= require libs/responsiveslides.min.js
//= require libs/jquery.skippr.js

// styleguide code
//= require "styleguide/js/functions.js"
//  require js/jquery.skippr.min.js # copied non-min version, to debug&patch
// require js/main.js


//  require js/superslides.js # copied to libs/superslides for easier monkey-patching
//= require functions_redesign.js

//= require helpers
//= require partials/helpers/site_version
//= require partials/helpers/alert
//= require partials/helpers/product_side_selector_panel
//= require partials/helpers/modal

// show old quiz in popup with iframe
// require partials/style/popup

//= require partials/product_collection.js
//require partials/product_customisation.js

//= require partials/email_newsletter_subscriber
//= require partials/email_capture_modal
//= require partials/mobile_menu
//= require partials/helpers/tracker.js.coffee
//= require partials/helpers/error_messages.js.coffee

// product details with related
//= require partials/product_details.js
//= require partials/inputs/new.js.coffee
//= require partials/inputs/product_option_selectors.js.coffee
//= require partials/helpers/product_images_slider.js.coffee
//= require partials/helpers/product_variants_selector.js.coffee

// shopping cart & bag & moodboard
//= require partials/helpers/shopping_cart
//= require partials/helpers/user_moodboard
//= require partials/product_collection_moodboard_links
//= require partials/shopping_bag
//= require partials/shopping_cart_summary

//= require partials/checkout/page
//= require partials/checkout/address
//= require partials/checkout/payment

// Profile/Account Settings
//= require partials/account_settings_page

jQuery(document).ready(function($){
  // function add_script(src) {
  //   var script_element = document.createElement('script');
  //   script_element.setAttribute('src', src);
  //   script_element.setAttribute('type', 'text/javascript')
  //   document.head.appendChild(script_element);
  //   return true
  // };
  //
  // add_script('/assets/javascripts/styleguide/js/sg-scripts.js');


	$('#forgot-password').on('click', function(e) {
		e.preventDefault();
		email = $('#spree_user_email').val()
		window.location = $(this).attr('href') + '?email=' + email;
	});

  //home page slider
  $(function() {
    $(".rslides").responsiveSlides({
    auto: true,             // Boolean: Animate automatically, true or false
    pager: true,           // Boolean: Show pager, true or false
    speed: 3000,            // Integer: Speed of the transition, in milliseconds
    timeout: 6000,          // Integer: Time between slide transitions, in milliseconds
    });
  });
})
