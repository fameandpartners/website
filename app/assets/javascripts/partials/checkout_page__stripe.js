/*
eslint-disable
*/
(function() {
  if ("stripe" in window) {
    var stripePending = false;
    var form = $('.js-payment-form');
    var elements = stripe.elements();

    if ($('.js-card-element').length){
      var stripeInputWrapper = $('.js-card-element-container');

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
      card.mount('.js-card-element');


      card.addEventListener('change', function(event) {
        var displayError = $('.js-card-errors');

        if (event.error) {
          displayError.text(event.error.message);
          stripeInputWrapper.addClass(stripeInputError);
        } else {
          displayError.text('');
          stripeInputWrapper.removeClass(stripeInputError);
        }

        if (event.empty) {
          stripeInputWrapper.removeClass(stripeInputDirty);
        } else {
          stripeInputWrapper.addClass(stripeInputDirty);
        }

      });

      card.addEventListener('focus', function(event) {
        stripeInputWrapper.addClass(stripeInputFocus);
      });

      card.addEventListener('blur', function(event) {
        stripeInputWrapper.removeClass(stripeInputFocus);
      });


      // Create a token or display an error when the form is submitted.
      form.on('submit', function(event) {
        event.preventDefault();
        if(stripePending) {
          console.log("Too fast, already processing");
          return null;
        }
        stripePending = true;
        // $('#payment-form.StripeForm button').toggleClass('hide');
        stripe.createToken(card).then(function(result) {
          if (result.error) {
            // Inform the user if there was an error
            stripePending = false;
            console.log("Create Token complete, setting stripePending to false");
            displayError(result.error.message);
          } else {
            // Send the token to your server
            stripeTokenHandler(result.token);
          }
        });
      });
    }
  }

  function displayError(message) {
    var errorElement = $('.js-card-errors');
    errorElement.textContent = message;

    stripeInputWrapper.addClass(stripeInputError);
  }

  function stripeTokenHandler(token) {
    // Insert the token ID into the form so it gets submitted to the server
    var params = {};
    var payment_method_id = $("#StripePaymentMethodID").val();
    var card = {};
    card[payment_method_id] = {
                                "cc_type": token.card.brand.toLowerCase(),
                                "gateway_payment_profile_id": token.id,
                              };
    params["authenticity_token"] = $('meta[name="csrf-token"]').attr('content');
    params["payment_source"] = card;
    params["_method"] = "put";
    params["state"] = "payment";
    params["order"] = {"payments_attributes": [{"payment_method_id": payment_method_id}] };

    $.ajax({
      type: 'POST',
      url: $('.js-payment-form').attr('action'),
      data: JSON.stringify(params),
      dataType: 'script',
      contentType: 'application/json',
      error: function(xhr, textStatus, errorThrown) {
        try {
          var errorMessage = JSON.parse(xhr.responseText).message;
          displayError("Unknown error occured");
        }
        catch (e) {
          console.log(e);
          stripePending = false;
        }
      },
      always: function() {
        stripePending = false;
      }

    });
  }

})();
