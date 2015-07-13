$(document).ready(function () {
  $('#locale').val($('.nav-tabs li[class=\"active\"] a').text());
  $('#locale').closest(".form-group").hide();
});
