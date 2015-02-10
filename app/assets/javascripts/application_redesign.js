// our code
//= require jquery
//= require libs/underscore-min

// styleguide code
//= require js/snap.svg-min.js
//= require js/modernizr.custom.js
//= require js/scrollspy.js
//= require js/dropdown.js
//= require js/svgicons-config.js
//= require js/svgicons.js
//= require js/jquery.skippr.min.js
//= require js/classie.js
//= require js/selectFx.js
//= require js/alert.js

//= require js/sg-plugins.js
// require js/sg-scripts.js
//= require js/functions.js
//= require functions_redesign.js

//= require partials/helpers/site_version
//= require popups/style_quiz
//= require partials/product_collection
//= require partials/helpers/tracker.js.coffee

//require js/sg-scripts.js should be done after page loaded.
jQuery(document).ready(function($){
  var sg_script = document.createElement('script');
  sg_script.setAttribute('src','//assets/js/sg-scripts.js');
  document.head.appendChild(sg_script);
})
