$('#buyWithMasterPassDiv').click(function() {
    var masterpass_overlay = $('#buyWithMasterPassOverlayDiv');
    masterpass_overlay.css({"width": "100%", "height": "100%"});

    var spinner = new Spinner().spin();
    masterpass_overlay.append(spinner.el);

    $.getJSON("/masterpass/cart?payment_method_id=#{payment_method.id}").done(
        function(data) {
            spinner.stop();
            masterpass_overlay.css({"width": 0, "height": 0});

            if (data.hasOwnProperty('request_token') && data.hasOwnProperty('callback_domain')
                && data.hasOwnProperty('checkout_identifier') && data.hasOwnProperty('shipping_suppression')
                && data.hasOwnProperty('accepted_cards') && data.hasOwnProperty('cart_callback_path')) {
                MasterPass.client.checkout({
                    "requestToken": data.request_token,
                    "callbackUrl": data.cart_callback_path,
                    "merchantCheckoutId": data.checkout_identifier,
                    "allowedCardTypes": data.accepted_cards,
                    "cancelCallback": data.callback_domain,
                    "suppressShippingAddressEnable": data.shipping_suppression,
                    "loyaltyEnabled": "false",
                    "requestBasicCheckout": false,
                    "version":"v6"
                });

                if (data.hasOwnProperty('commerce_tracking') && data.commerce_tracking == true) {
                    var axel = Math.random() + "";
                    var a = axel * 10000000000000;
                    document.write('<iframe src="https://4754606.fls.doubleclick.net/activityi;src=4754606;type=mpau;cat=famep00;ord=' + a + '?" width="1" height="1" frameborder="0" style="display:none"></iframe>');
                }
            }
        });
});