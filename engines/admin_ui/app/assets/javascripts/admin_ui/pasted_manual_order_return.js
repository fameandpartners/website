var prefillPastedManualReturn = function(el, event) {
  var manualOrderKeys = [
        "date",
        "notes",
        "order_number",
        "customer_name",
        "number",
        "email_address",
        "country",
        "promocode",
        "style",
        "style_number",
        "cost",
        "colour",
        "qty",
        "size",
        "customisation",
        "customisation_notes",
        "address",
        "postcode",
        "order_note",
        "order_date",
        "completed_by",
        "request_date",
        "shipped_date",
        "tracking_number"
      ];

  event.preventDefault();
  if (event && event.clipboardData && event.clipboardData.getData) {
    var manualOrderPasteData = event.clipboardData.getData('text/plain').split("\t");

    if (manualOrderPasteData.length >= manualOrderKeys.length) {
      var manualOrderObject = _.object(manualOrderKeys, manualOrderPasteData);

      fillPastedManualReturnForm(manualOrderObject);

      el.value = JSON.stringify(manualOrderObject);
    } else {
      cleanAlert("Couldn't extract data from pasted text");
    }
  }
};

var fillPastedManualReturnForm = function(moo) {
  var formElementPrefix = '#forms_item_returns_manual_order_return_';

  $(formElementPrefix + 'order_number'          ).val(moo['order_number']);
  $(formElementPrefix + 'contact_email'         ).val(moo['email_address']);
  $(formElementPrefix + 'customer_name'         ).val(moo['customer_name']);
  $(formElementPrefix + 'product_name'          ).val(moo['style']);
  $(formElementPrefix + 'product_style_number'  ).val(moo['style_number']);
  $(formElementPrefix + 'product_colour'        ).val(moo['colour']);
  $(formElementPrefix + 'product_size'          ).val(moo['size']);
  $(formElementPrefix + 'product_customisations').val(moo['customisation']);
  $(formElementPrefix + 'order_payment_date'    ).val(moo['order_date']);
  $(formElementPrefix + 'request_notes'         ).val(moo['customisation_notes']);
};

function cleanAlert(message) {
  if (!("Notification" in window)) {
    alert(message);
  } else {
    // Notification just calls if permission has previously been granted.
    Notification.requestPermission(function (permission) {
      if (permission === "granted") {
        var notification = new Notification(message);
      } else {
        alert(message);
      }
    });
  }
}
