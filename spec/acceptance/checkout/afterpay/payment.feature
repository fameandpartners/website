Feature: Complete Guest Checkout (Paying with Afterpay)

  # Note: VCR is recording Afterpay interactions!
  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags
    And The "afterpay" feature is enabled

  @javascript @vcr @shorter_cassette_names @selenium
  Scenario: Successfully Buy a Dress
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Street Address          | Street X                         |
      | Street Address (cont'd) | House Y                          |
      | City                    | Melbourne                        |
      | Phone Number            | 2255-4422                        |
      | Postcode                | 12345                            |
    And I click on "Pay Securely" button
    And I click on "Continue With Afterpay" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | name       | Roger That                       |
      | address1   | Street X                         |
      | suburb     | Suburb                           |
      | state      | State                            |
      | postcode   | 1234                             |
      | cardName   | Roger That                       |
      | cardNumber | 5520000000000000                 |
      | expiryDate | 0230                             |
      | cardCVC    | 123                              |
    Then I should see my order placed, with "Connie" dress, "AU 14" size and "319.00" price

  @javascript @vcr @shorter_cassette_names @selenium
  Scenario: Afterpay cannot process user payment, user sees an error
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Street Address          | Street X                         |
      | Street Address (cont'd) | House Y                          |
      | City                    | Melbourne                        |
      | Phone Number            | 2255-4422                        |
      | Postcode                | 12345                            |
    And I click on "Pay Securely" button
    And I click on "Continue With Afterpay" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | name       | Roger That                       |
      | address1   | Street X                         |
      | suburb     | Suburb                           |
      | state      | State                            |
      | postcode   | 1234                             |
      | cardName   | Roger That                       |
      | cardNumber | 5520000000000000                 |
      | expiryDate | 0230                             |
      | cardCVC    | 123                              |
    Then I should see "Afterpay payment failed, please try again later."

  @javascript @vcr @shorter_cassette_names
  Scenario: Afterpay cannot create order
    Given Afterpay API is not available
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Street Address          | Street X                         |
      | Street Address (cont'd) | House Y                          |
      | City                    | Melbourne                        |
      | Phone Number            | 2255-4422                        |
      | Postcode                | 12345                            |
    And I click on "Pay Securely" button
    Then I should see "Afterpay is not available at the moment. Please, try another payment method."
