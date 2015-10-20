//---------
// Our code
//---------
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require jquery-fileupload/vendor/jquery.ui.widget
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload

//= require libs/underscore-min
//= require bootstrap

//= require libs/jquery.dotdotdot.min

// React
//= require react
//= require react_ujs
//= require components

// node modules
//= require slick-carousel/slick/slick.min.js

//---------------------------
// Spree have this by default
//---------------------------
//= require libs/snap.svg-min.js
//= require libs/vex.combined.min.js
//= require libs/jquery.cookie
//= require libs/jquery.chosen.min
//= require libs/soundcloud/sc-player
//= require libs/jquery.hoverable.js
//= require libs/superslides.js
//= require libs/responsiveslides.min.js
//= require libs/jquery.skippr.js

//----------------
// Styleguide code
//----------------
//= require "styleguide/js/functions.js"
//  require js/jquery.skippr.min.js # copied non-min version, to debug&patch
// require js/main.js

//  require js/superslides.js # copied to libs/superslides for easier monkey-patching
//= require functions_redesign.js

//----------------
// Masterpass libs
//----------------
//= require libs/spin.min.js

//--------------------------
// Helpers
//--------------------------
//= require helpers
//= require partials/helpers/site_version
//= require partials/helpers/alert
//= require partials/helpers/product_side_selector_panel
//= require partials/helpers/modal
//= require partials/helpers/facebook_tracking_hook
//= require partials/helpers/truncate
//= require partials/helpers/bs-tabs

//-----------------------------------
// Show old quiz in popup with iframe
//-----------------------------------
// require partials/style/popup

//= require partials/product_collection.js
//require partials/product_customisation.js

//= require partials/email_newsletter_subscriber
//= require partials/email_capture_modal
//= require partials/helpers/tracker.js.coffee
//= require partials/helpers/error_messages.js.coffee

//-----------------------------
// Product details with related
//-----------------------------
//= require partials/product_details.js
//= require partials/inputs/new.js.coffee
//= require partials/inputs/product_option_selectors.js.coffee
//= require partials/helpers/product_images_slider.js.coffee
//= require partials/helpers/product_variants_selector.js.coffee
//= require partials/product_collection_image_hover.js.coffee

//--------------------------------
// Shopping cart & bag & moodboard
//--------------------------------
//= require partials/helpers/shopping_cart
//= require partials/helpers/user_moodboard
//= require partials/product_collection_moodboard_links
//= require partials/shopping_bag
//= require partials/shopping_cart_summary
//= require partials/side_menu

//= require partials/user_order_returner

//= require partials/checkout_page

// Profile/Account Settings
//= require partials/account_settings_page

// campaigns
//= require partials/fitgau_reminder

jQuery(document).ready(function($){
  $('#forgot-password').on('click', function(e) {
    e.preventDefault();
    email = $('#spree_user_email').val()
    window.location = $(this).attr('href') + '?email=' + email;
  });

  //home page slider
  $(function() {
    $(".rslides").responsiveSlides({
    auto: false,             // Boolean: Animate automatically, true or false
    pager: true,           // Boolean: Show pager, true or false
    speed: 3000,            // Integer: Speed of the transition, in milliseconds
    timeout: 6000,          // Integer: Time between slide transitions, in milliseconds
    });
  });

})
