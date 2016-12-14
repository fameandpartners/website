'use strict';
// truncate text block
(function ($) {

  // to truncate single line, use js free solution. Use class 'txt-truncate-1'

  // truncate multiple lines lines
  $('.txt-truncate-block').dotdotdot({
    tolerance: 0
  });

}(jQuery));