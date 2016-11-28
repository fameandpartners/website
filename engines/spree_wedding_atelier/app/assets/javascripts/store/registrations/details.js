$.fn.incrementButton = function(){

  if (!this.is('input[type="number"]')) {
    console.warn('[incrementButton] <input> type must equal number');
    return;
  }

  debugger;

  this
    .wrap( "<div class='number-field'></div>" )
    .before('<span class="number-field-button">-</span>')
    .after('<span class="number-field-button">+</span>')
    .css('outline', '2px solid red')
    .css('width', '80%');
};

$(document).ready(function() {

$('.number_field').incrementButton();

});
