SpreePaypalExpress = {
  hidePaymentSaveAndContinueButton: function(paymentMethod) {
    if (SpreePaypalExpress.paymentMethodID && paymentMethod.val() == SpreePaypalExpress.paymentMethodID) {
      $('.continue').hide();
    } else {
      $('.continue').show();
    }
  }
}

$(document).ready(function() {
  checkedPaymentMethod = $('div[data-hook="checkout_payment_step"] input[type="radio"]:checked');
  if (checkedPaymentMethod.length > 0) {
    SpreePaypalExpress.hidePaymentSaveAndContinueButton(checkedPaymentMethod);
    paymentMethods = $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function (e) {
      SpreePaypalExpress.hidePaymentSaveAndContinueButton($(e.target));
    });
  }
})
