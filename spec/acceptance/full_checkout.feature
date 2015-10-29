Feature: Full checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly

  @javascript @no_vcr
  Scenario: Buy a Dress
    When I am on Connie dress page
    And I select "US 10" size
    And I click on "Add to Cart" button
    And I click on "CHECKOUT" button
    Then I fill in form fields with:
      | Email                   | my@email.com |
      | First Name              | Roger        |
      | Last Name               | That         |
      | Street Address          | Street X     |
      | Street Address (cont'd) | House Y      |
      | City                    | Melbourne    |
      | Phone Number            | 2255-4422    |
      | Zipcode                 | 12345        |
    And I select "California" state
    And I select "United States" country
    And I click on "Pay Securely" button
    And I fill in credit card information:
      | Card number      | 5520000000000000  |
      | Name on card     | Zaphod Beeblebrox |
      | CVC              | 123               |
      | Expiration Month | 10                |
      | Expiration Year  | 2050              |
    And I click on "Place My Order" button
    Then I should see my order placed, with "Connie" dress, "10" size
