var stripe = Stripe('pk_test_W2TXpgZbnoebFKeDzNW74xhB');
var elements = stripe.elements();


// Custom styling can be passed to options when creating an Element.
var style = {
  base: {
    // Add your base input styles here. For example:
    fontSize: '16px',
    lineHeight: '24px'
  }
};

// Create an instance of the card Element
var card = elements.create('card', {style: style});

// Add an instance of the card Element into the `card-element` <div>
card.mount('#card-element');


card.addEventListener('change', function(event) {
  var displayError = document.getElementById('card-errors');
  if (event.error) {
    displayError.textContent = event.error.message;
  } else {
    displayError.textContent = '';
  }
});


// Create a token or display an error when the form is submitted.
var form = document.getElementById('payment-form');
form.addEventListener('submit', function(event) {
  event.preventDefault();

  stripe.createToken(card).then(function(result) {
    if (result.error) {
      // Inform the user if there was an error
      var errorElement = document.getElementById('card-errors');
      errorElement.textContent = result.error.message;
    } else {
      // Send the token to your server
      stripeTokenHandler(result.token);
    }
  });
});


function stripeTokenHandler(token) {
  // Insert the token ID into the form so it gets submitted to the server
//   var form = document.getElementById('payment-form');
//   var hiddenInput = document.createElement('input');
//   var cardInfo = {
//                     "1": {
//                           "gateway_payment_profile_id": token.id,
//                           "cc_type": token.card.brand
//                        }
//                  };
//   hiddenInput.setAttribute('type', 'hidden');
//   hiddenInput.setAttribute('name', 'payment_source');
//   hiddenInput.setAttribute('value', JSON.stringify(cardInfo));
//   form.appendChild(hiddenInput);

//   var hiddenOrder = document.createElement('input');
//   var orderInfo = {
//                     payment_attributes: [ {payment_method_id: 1} ]
//                   };
//   hiddenOrder.setAttribute('type', 'hidden');
//   hiddenOrder.setAttribute('name', 'order');
//   hiddenOrder.setAttribute('value', orderInfo);
//   form.appendChild(hiddenOrder);

//   var hiddenInput_AuthToken = document.createElement('input');
//   hiddenInput_AuthToken.setAttribute('type', 'hidden');
//   hiddenInput_AuthToken.setAttribute('name', 'authenticity_token');
//   hiddenInput_AuthToken.setAttribute('value', $('meta[name="csrf-token"]').attr('content'));
//   form.appendChild(hiddenInput_AuthToken);
// debugger;
//   // Submit the form
//   form.submit();

  var params = {};
  params["authenticity_token"] = $('meta[name="csrf-token"]').attr('content');
  params["payment_source"] = {"20":
                                    {
                                      "cc_type": token.card.brand.toLowerCase(),
                                      "gateway_payment_profile_id": token.id
                                    }
                             };
  params["_method"] = "put";
  params["state"] = "payment";
  params["order"] = {"payments_attributes": [{"payment_method_id": "20"}] };


  $.ajax({
    type: 'POST',
    url: form.action,
    data: JSON.stringify(params),
    dataType: 'script',
    contentType: 'application/json'
  });
}
