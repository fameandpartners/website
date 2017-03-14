$.fn.incrementButton = function(config){

  if (this.length === 0) {
    return;
  }

  var $input = $(this);

  if (!$input.is('input[type="number"]')) {
    console.warn('[incrementButton] <input> type must equal number');
    return;
  }

  if (config && config.onChange) {
    $input.on("change", function() {
      if(this.value == ''){
        this.value = 0;
       }
      config.onChange({target: this});
    });
  }

  $input.on("keypress", function(e){
    e.preventDefault();
  });

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

    $input.val(newVal).change();
  });

  $incButton.on("click", function() {
    var oldValue = parseInt($input.val(), 10);
    var newVal = ++oldValue;
    var max = parseInt($input.attr('max'));

    if (isNaN(newVal)) {
      $input.val(0);
      return;
    }
    if(newVal >= max){
      $input.val(oldValue = max);
      return;
    }

    $input.val(newVal).change();
  });

};
