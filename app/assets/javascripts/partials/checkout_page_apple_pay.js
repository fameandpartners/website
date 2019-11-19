// (function() {

  var cartData = window.ApplicationStateData['CartData'];
  var paymentRequest = stripe.paymentRequest({
    country: window.ApplicationStateData['currentSiteVersion'] == 'USA' ? 'US' : 'AU',
    currency: cartData['currency'].toLowerCase(),
    total: {
      label: cartData['number'],
      amount: Number(cartData['total']) * 100,
    },
    requestPayerName: true,
    requestPayerEmail: true,
  });

  var elements = stripe.elements();
  var prButton = elements.create('paymentRequestButton', {
    paymentRequest: paymentRequest,
  });

  // Check the availability of the Payment Request API first.
  paymentRequest.canMakePayment().then(function(result) {
    if (result) {
      $("#payment-request-button").click(function() {
        paymentRequest.show();
      });
    } else {
      $("#payment-request-button").style.display = 'none';
    }
  });

  paymentRequest.on('token', function(ev) {
    // Send the token to your server to charge it!
    console.log(ev.token);
    applePayTokenHandler(ev);
  });

  function applePayTokenHandler(ev) {
    var token = ev.token;
    var payerName = ev.payerName;

    var params = {};
    var payment_method_id = $("#ApplePayPaymentMethodID").val();
    var card = {};
    card[payment_method_id] = {
                                "cc_type": token.card.brand.toLowerCase(),
                                "gateway_payment_profile_id": token.id,
                                "number": token.card.last4,
                                "month": token.card.exp_month,
                                "year": token.card.exp_year,
                                "last_name": payerName
                              };
    params["authenticity_token"] = $('meta[name="csrf-token"]').attr('content');
    params["payment_source"] = card;
    params["_method"] = "put";
    params["state"] = "payment";
    params["order"] = {"payments_attributes": [{"payment_method_id": payment_method_id}] };
    params["return_type"] = $('#return_type').val();
    console.log(JSON.stringify(params));

    $.ajax({
      type: 'POST',
      url: '/checkout/update/payment',
      data: JSON.stringify(params),
      dataType: 'script',
      contentType: 'application/json',
      error: function(xhr, textStatus, errorThrown) {
        try {
          var errorMessage = JSON.parse(xhr.responseText).message;
          if (errorMessage === "StaleCart") {
            window.location.reload(true);
          }
        }
        catch (e) {
          console.log(e);
          // stripePending = false;
        }
        ev.complete('fail');
      },
      always: function() {
        // stripePending = false;
      },
      success: function() {
        ev.complete('success');
      }
    });
  }
// })();
