Feature: Complete Guest Checkout (Paying with Afterpay)

  # Note: VCR is recording Afterpay interactions!
  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags
    And The "afterpay" feature is enabled
    And The "getitquick_unavailable" feature is enabled

  @javascript @vcr @shorter_cassette_names @selenium @afterpay
  Scenario: Successfully Buy a Dress
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Address                 | Street X                         |
      | Street Address (line 2) | House Y                          |
      | City                    | Melbourne                        |
      | Phone                   | 2255-4422                        |
      | Postcode                | 0872                             |
    And I click on "Continue to payment" button
    And I click on "Afterpay" link
    And I click on "Pay with" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | cardCVC    | 123                              |
    Then I should see my order placed, with "Connie" dress, "AU 14" size and "319.00" price

  @pending @javascript @vcr @shorter_cassette_names @selenium @afterpay
  Scenario: Successfully Buy a Dress (Ship to Singapore)
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I select "Singapore" country and "SINGAPORE" state for ship
    And I fill in shipping form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Address                 | Street X                         |
      | Street Address (line 2) | House Y                          |
      | City                    | Melbourne                        |
      | Phone                   | 2255-4422                        |
      | Postcode                | 520311                           |
    And I uncheck This is also my billing address
    Then I select "Australia" country and "Queensland" state for bill
    And I fill in billing form fields with:
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Address                 | Street X                         |
      | Street Address (line 2) | House Y                          |
      | City                    | Melbourne                        |
      | Phone                   | 2255-4422                        |
      | Postcode                | 0872                             |
    And I agree with shipping fee
    And I click on "Continue to payment" button
    And I click on "Afterpay" link
    And I click on "Pay with" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | cardCVC    | 123                              |
    Then I should see my order placed, with "Connie" dress, "AU 14" size and "319.00" price

  @javascript @vcr @shorter_cassette_names @selenium @afterpay
  Scenario: Afterpay cannot process user payment, user sees an error
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Address                 | Street X                         |
      | Street Address (line 2) | House Y                          |
      | City                    | Melbourne                        |
      | Phone                   | 2255-4422                        |
      | Postcode                | 0872                             |
    And I click on "Continue to payment" button
    And I click on "Afterpay" link
    And I click on "Pay with" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | cardCVC    | 123                              |
    Then I should see "Afterpay payment failed, please try again later."

  @javascript @vcr @shorter_cassette_names @afterpay
  Scenario: Afterpay cannot create order
    Given Afterpay API is not available
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Address                 | Street X                         |
      | Street Address (line 2) | House Y                          |
      | City                    | Melbourne                        |
      | Phone                   | 2255-4422                        |
      | Postcode                | 0872                             |
    And I click on "Continue to payment" button
    And I click on "Afterpay" link
    Then I should see "Afterpay is not available at the moment. Please, try another payment method."
