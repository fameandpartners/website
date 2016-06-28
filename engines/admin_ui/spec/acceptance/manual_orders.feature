Feature: Assign colors to products

  Background:
    Given A sample database with valid data
    And The example admin is signed in

  @javascript
  Scenario:
    When I am on the manual orders page
    And I click on "Create" link
    And I select "Connie" product from chosen style name select box
    And I select size "US4/AU8" from chosen size select box
    And I select skirt length "Standart" from chosen length select box
    And I select "Black" color from chosen color select box
    Then I should see "$289.0 USD"
    Then I should have black dress image
    And I select "Australia" from chosen country select box
    Then I should see "$319.0 AUD"
