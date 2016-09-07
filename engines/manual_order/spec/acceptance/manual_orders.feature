Feature: Create manual orders

  Background:
    Given A sample database with valid data
    And The example admin is signed in
    And The example user created with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Street Address          | Street X       |
      | Street Address 2        | House Y        |
      | City                    | Melbourne      |
      | Phone Number            | 2255-4422      |
      | Zipcode                 | 12345          |
      | Country                 | United States  |
      | State                   | California     |
    And The example completed order exists with this user

  @javascript
  Scenario:
    When I am on the new manual order page
    And I select "Connie" product from chosen style name select box
    And I select size "US4/AU8" from chosen size select box
    And I select skirt length "Standard" from chosen length select box
    And I select "Black" color from chosen color select box
    Then I should see "$289.0 USD"
    Then I should have black dress image
    And I select "Australia" from chosen country select box
    Then I should see "$319.0 AUD"
    And I click on "Adjust" link
    And I fill adjustment fields
    And I click on "OK" link
    And I select "Roger That" from chosen customers select box
    Then I should see correct user data prefilled
    And I click on "Complete Order and Send for Manufacturing" button
    Then I should get right order results
