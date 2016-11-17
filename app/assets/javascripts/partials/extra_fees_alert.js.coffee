window.page ||= {}

page.initExtraFeesAlert = () ->
  alert = {
    countryChanged: () ->
      element = $(this)

      if window.checkout_page.extraFeesAlert.isBillAddressCountry(element)
        countryHasShippingFee = window.checkout_page.countries[element.val()]['shipping_fee']
        countryHasDutyFee = window.checkout_page.countries[element.val()]['duty_fee']
        selectedCountry = window.checkout_page.extraFeesAlert.selectedCountry(element)

        $extraFeeBlock = $('#extra_fee_alert')
        $shippingFeeBlock = $extraFeeBlock.find('.shipping_fee_alert')
        $dutyFeeBlock = $extraFeeBlock.find('.duty_fee_alert')
        $countryNameBlock = $extraFeeBlock.find('.country_name')

        $countryNameBlock.text(selectedCountry)

        if countryHasShippingFee
          $shippingFeeBlock.show()
        else
          $shippingFeeBlock.hide()

        if countryHasDutyFee
          $dutyFeeBlock.show()
        else
          $dutyFeeBlock.hide()

        if countryHasShippingFee || countryHasDutyFee
          $extraFeeBlock.show()
        else
          $extraFeeBlock.hide()

      window.checkout_page.extraFeesAlert.uncheckInternationalShippingFeeCheckbox()
      window.checkout_page.extraFeesAlert.changeButtonStatus()

    isBillAddressCountry: (element) ->
      bill_address_select_id = 'order_bill_address_attributes_country_id'
      ship_address_select_id = 'order_ship_address_attributes_country_id'

      if element.attr('id') == bill_address_select_id 
        return true
      else
        useBillingAddressToShip = $("input[name='ship_to_address']").is(':checked')
        return element.attr('id')  == ship_address_select_id && useBillingAddressToShip

    shippingFeeHasToBeApplied: () ->
      if $("input[name='ship_to_address']").is(':checked')
        element = $('#order_bill_address_attributes_country_id')
      else
        element = $('#order_ship_address_attributes_country_id')
      window.checkout_page.countries[element.val()]['shipping_fee']

    internationalShippingFeeCheckboxIsVisible: () ->
      $('#international_shipping_fee').is(':visible')

    internationalShippingFeeCheckboxIsChecked: () ->
      $('#international_shipping_fee').is(':checked')

    uncheckInternationalShippingFeeCheckbox: () ->
      $('#international_shipping_fee').removeAttr('checked')

    internationalShippingFeeCheckboxClicked: () ->
      if $(this).is(':checked')
        $('button[name="pay_securely"]').prop('disabled', false)
      else
        $('button[name="pay_securely"]').prop('disabled', true)

    selectedCountry: (element) ->
      result = element.children(':selected').html().match(/\w+(\s\w+)*/)
      if result
        result[0]
      else
        result

    changeButtonStatus: () ->
      if @internationalShippingFeeCheckboxIsVisible() and not @internationalShippingFeeCheckboxIsChecked()
        $('button[name="pay_securely"]').prop('disabled', true)
      else
        $('button[name="pay_securely"]').prop('disabled', false)
  }

  window.checkout_page.extraFeesAlert = alert
  page
