Feature: Afterpay on Australian's Website Checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And The "afterpay" feature is enabled
    And The "getitquick_unavailable" feature is enabled

  @javascript @vcr @shorter_cassette_names
  Scenario: I see Afterpay payment method on Australian Site Version
    # See on Australia site version
    When I select "Connie" dress on Australia, with "AU 14", "147" and proceed to checkout
    Then I select "Australia" country and "Queensland" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Address                 | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | Postcode                | 12345          |
    And I click on "Continue to payment" button
    Then I should see "Afterpay"

    # Do not see on USA site version
    When I select "Connie" dress on USA, with "US 10", "59" and proceed to checkout
    Then I select "United States" country and "California" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Address                 | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | Zipcode                 | 12345          |
    And I click on "Continue to payment" button
    Then I should not see "Afterpay"
