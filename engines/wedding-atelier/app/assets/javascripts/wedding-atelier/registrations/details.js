$.fn.incrementButton = function(){
  var $input = $(this);

  if (!$input.is('input[type="number"]')) {
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
  $('.registrations__details-form.signup .js-number-field').incrementButton();

  $('.registrations__details-form #wedding_role').select2({
    minimumResultsForSearch: Infinity,
    placeholder: 'Please select your height'
  });

  $('.registrations__details-form .input-group').datepicker({
    format: "mm/dd/yyyy",
    autoclose: true,
    showOnFocus: true,
    startDate: moment().format('M/D/YYYY')
  }).on('show', function(e){
    $(this).addClass('active');
  }).on('hide', function(e){
    $(this).removeClass('active');
  });
});
