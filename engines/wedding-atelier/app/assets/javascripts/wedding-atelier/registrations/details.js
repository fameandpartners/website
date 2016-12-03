$.fn.incrementButton = function(){
  var $input = $(this);

  if (!$input.is('input[type="number"]')) {
    console.warn('[incrementButton] <input> type must equal number');
    return;
  }

  $input
    .wrap( "<div class='number-field'></div>" )
    .before('<span class="number-field-button dec">-</span>')
    .after('<span class="number-field-button inc">+</span>');

  if (parseInt($input.val(), 10) !== parseInt($input.val(), 10)) {
    $input.val(0);
  }

  var $decButton = $input.siblings('.dec');
  var $incButton = $input.siblings('.inc');

  $decButton.on("click", function() {
    var oldValue = parseInt($input.val(), 10);
    var newVal = --oldValue;

    if (oldValue < 0 || isNaN(newVal)) {
      $input.val(0);
      return;
    }

    $input.val(newVal);
  });

  $incButton.on("click", function() {
    var oldValue = parseInt($input.val(), 10);
    var newVal = ++oldValue;

    if (isNaN(newVal)) {
      $input.val(0);
      return;
    }

    $input.val(newVal);
  });

};

$(document).ready(function() {
  $('.js-number-field').incrementButton();

  $('#spree_user_event_role').select2({
    minimumResultsForSearch: Infinity
  });

  $('.input-group.date').datepicker({
    format: "mm/dd/yyyy",
    todayBtn: "linked",
    autoclose: true,
    showOnFocus: true
  }).on('show', function(e){
    $(this).addClass('active');
  }).on('hide', function(e){
    $(this).removeClass('active');
  });
});
