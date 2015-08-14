$(document).ready(function () {
  // initialize locale fields based on tab's name
  $('.locale').each(function() {
    tabName = $(this).closest(".tab-pane").attr("id");
    if (tabName == "tab-en-us") {
      $(this).val("en-US");
    } else if (tabName == "tab-en-au") {
      $(this).val("en-AU");
    }
  });

  // Hide locale fields
  $('.locale').closest(".form-group").hide();

  // Hide validation
  $('.validation-error').hide();

  // validate title and meta description before submit
  $('.save').click(function(e){
    e.preventDefault();

    validated = true;
    $('.translation-title').each(function(){
      if ($(this).val() == "")
      {
        validated = false;
      }
    });

    $('.translation-meta-description').each(function(){
      if ($(this).val() == "")
      {
        validated = false;
      }
    });

    if (!validated) {
      $('.validation-error').show();
    } else {
      $('.validation-error').hide();
      $('form').submit();
    }
  });
});
