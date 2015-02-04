// our code
//= require jquery

// styleguide code
//= require js/snap.svg-min.js
//= require js/modernizr.custom.js
//= require js/scrollspy.js
//= require js/dropdown.js
//= require js/svgicons-config.js
//= require js/svgicons.js
//= require js/jquery.skippr.min.js

//= require js/sg-plugins.js
// require js/sg-scripts.js
//= require js/functions.js
//= require functions_redesign.js


//require js/sg-scripts.js should be done after page loaded.
jQuery(document).ready(function($){

  var sg_script = document.createElement('script');
  sg_script.setAttribute('src','//assets/js/sg-scripts.js');
  document.head.appendChild(sg_script);

})
