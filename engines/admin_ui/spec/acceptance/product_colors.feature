Feature: Assign colors to products

  Background:
    Given A sample database with valid data
    And The example admin is signed in

  @javascript
  Scenario:
    When I am on the product colors page
    And I click on "Create a Color" link
    And I select "Connie" product from chosen select box
    And I select "Coral" color from chosen select box
    And I click on "Create" button
    Then I should see "Color 'coral' for the product 'Connie' successfully created"

  Scenario:
    When I am on the product colors page
    And I click on "Create a Color" link
    And I select "Connie" product from chosen select box
    And I click on "Create" button
    Then I should see "can't be blank"

