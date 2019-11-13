(function() {

  var paymentRequest = stripe.paymentRequest({
    country: 'US',
    currency: 'usd',
    total: {
      label: 'Demo total',
      amount: 1000,
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
      prButton.mount('#payment-request-button');
    } else {
      document.getElementById('payment-request-button').style.display = 'none';
    }
  });

  paymentRequest.on('token', function(ev) {
    // Send the token to your server to charge it!
    fetch('/charges', {
      method: 'POST',
      body: JSON.stringify({token: ev.token.id}),
      headers: {'content-type': 'application/json'},
    })
    .then(function(response) {
      if (response.ok) {
        // Report to the browser that the payment was successful, prompting
        // it to close the browser payment interface.
        ev.complete('success');
      } else {
        // Report to the browser that the payment failed, prompting it to
        // re-show the payment interface, or show an error message and close
        // the payment interface.
        ev.complete('fail');
      }
    });
  });
})();
