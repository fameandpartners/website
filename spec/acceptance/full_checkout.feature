Feature: Full checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly

  @javascript @selenium
  Scenario: Buy a Dress
    When I am on Connie dress page
    And I select "US 10" size
    And I click on "Add to Cart" button
    And I click on "CHECKOUT" button
#    And Input personal information
#    And I click on "Pay Securely" button
#    And I input my credit card information
#    And I click on "Place My Order" button
#    Then I should see my order placed
