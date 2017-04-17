Feature: Californian Taxes

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags

  @javascript
  Scenario: Californians Will Pay extra 7.5% for their orders
    When I select "Connie" dress on "USA", with "US 10", "Petite" and proceed to checkout
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Street Address          | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | Zipcode                 | 12345          |
    And I select "United States" country
    And I select "California" state
    And I click on "Continue to payment" button
    And I should see "California Tax $21.68"
    And I should see "Total$310.68"
    And I fill in form fields with:
      | Name on your card | Zaphod Beeblebrox |
      | Card number       | 5520000000000000  |
      | month             | 10                |
      | year              | 2050              |
      | card_code         | 123               |
    And I click on "Place your order now" button
    Then I should see my order placed, with "Connie" dress, "US 10" size and "289.00" price
    Then I should see "CALIFORNIA TAX $21.68"
