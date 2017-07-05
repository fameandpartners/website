var stripe = Stripe('pk_test_W2TXpgZbnoebFKeDzNW74xhB');
var elements = stripe.elements();

var stripeInputWrapper = document.getElementById('card-element-container');

// Stripe input container style classes
var stripeInputError = 'StripeForm__input-wrapper--error';
var stripeInputFocus = 'StripeForm__input-wrapper--focus';
var stripeInputDirty = 'StripeForm__input-wrapper--dirty';

// Custom styling can be passed to options when creating an Element.
var style = {
  base: {
    // Add your base input styles here. For example:
    fontSize: '16px',
    lineHeight: '24px',
    color: '#484848',

    '::placeholder': {
      color: '#a4a4a4'
    }
  },
  complete: {
    color: '#444'
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
    jsAddClass(stripeInputWrapper, stripeInputError);
  } else {
    displayError.textContent = '';
    jsRemoveClass(stripeInputWrapper, stripeInputError);
  }

  if (event.empty) {
    jsRemoveClass(stripeInputWrapper, stripeInputDirty);
  } else {
    jsAddClass(stripeInputWrapper, stripeInputDirty);
  }

});

card.addEventListener('focus', function(event) {
  jsAddClass(stripeInputWrapper, stripeInputFocus);
});

card.addEventListener('blur', function(event) {
  jsRemoveClass(stripeInputWrapper, stripeInputFocus);
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
  var form = document.getElementById('payment-form');
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  var hiddenInput_AuthToken = document.createElement('input');
  hiddenInput_AuthToken.setAttribute('type', 'hidden');
  hiddenInput_AuthToken.setAttribute('name', 'authenticity_token');
  hiddenInput_AuthToken.setAttribute('value', $('meta[name="csrf-token"]').attr('content'));
  form.appendChild(hiddenInput_AuthToken);

  // Submit the form
  form.submit();
}
