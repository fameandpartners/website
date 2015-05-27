$(document).ready(function () {
  $('form.shipment_tracking_number_form').bind("ajax:success", function (e, data, status, xhr) {
        e.target.outerHTML = data.html_replacement;
      }
  ).bind("ajax:error", function (e, xhr, status, response) {
        try {        result = JSON.parse(xhr.responseText); }
        catch(err) { result = { errors: ["Unknown error", err] }; }
        window.alert("Unable to save the tracking number information." + result.errors);
      }
  );
});
