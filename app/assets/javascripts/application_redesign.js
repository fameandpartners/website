//---------
// Our code
//---------
//= require libs/typekit.min
//= require jquery_ujs

//= require libs/underscore-min
//= require libs/validator.min

//= require modernizr-custom

//--------------
// Bootstrap JS
//--------------
//= require bootstrap/transition
//= require bootstrap/alert
//= require bootstrap/collapse
//= require bootstrap/dropdown
//= require bootstrap/modal
//= require bootstrap/tab
//= require bootstrap/affix
//= require bootstrap/scrollspy


//---------------------------
// Spree have this by default
//---------------------------
//= require libs/vex.combined.min.js
//= require libs/jquery.cookie
//= require libs/jquery.chosen.min


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
//= require partials/helpers/modal
//= require partials/helpers/bs-tabs
//= require partials/helpers/collapse_toggle


//= require partials/returns_modal
//= require partials/helpers/tracker.js
//= require partials/helpers/error_messages.js.coffee

//-----------------------------
// Product details with related
//-----------------------------
//= require partials/inputs/new.js.coffee

//--------------------------------
// Shopping cart & bag & moodboard
//--------------------------------
//= require partials/helpers/shopping_cart
//= require partials/shopping_cart_summary
//= require partials/shopping_cart_delivery_times

//= require partials/checkout_page
//= require partials/checkout_page__stripe
//= require partials/extra_fees_alert
//= require partials/checkout_page_apple_pay

jQuery(document).ready(function($){
  $('body').addClass('ready');
});
