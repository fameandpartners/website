Feature: Afterpay on Australian's Website Checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And The "afterpay" feature is enabled

  @javascript
  Scenario: I see Afterpay payment method on Australian Site Version
    # See on Australia site version
    # TODO: these steps are repeating too much. Should be extracted.
    When I am on Connie dress page
    Then I select "Australia" site version
    And I select "AU 14" size
    And I select "Petite" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Street Address          | Street X       |
      | Street Address (cont'd) | House Y        |
      | City                    | Melbourne      |
      | Phone Number            | 2255-4422      |
      | Postcode                | 12345          |
    And I click on "Pay Securely" button
    Then I should see "Afterpay"

    # Do not see on USA site version
    When I am on Connie dress page
    Then I select "USA" site version
    And I select "US 10" size
    And I select "Tall" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "United States" country and "California" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Street Address          | Street X       |
      | Street Address (cont'd) | House Y        |
      | City                    | Melbourne      |
      | Phone Number            | 2255-4422      |
      | Zipcode                 | 12345          |
    And I click on "Pay Securely" button
    Then I should not see "Afterpay"
