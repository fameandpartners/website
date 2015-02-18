// our code
//= require jquery
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
//= require partials/product_collection.js
//= require partials/helpers/tracker.js.coffee

// product details with related
//= require partials/product_details.js
//= require partials/inputs/new.js.coffee
//= require partials/helpers/product_images_slider.js.coffee
//= require partials/helpers/product_variants_selector.js.coffee

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
})
