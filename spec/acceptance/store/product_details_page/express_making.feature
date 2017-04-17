Feature: PDP's Express Making

  Background:
    Given A sample database with valid data
    And The "getitquick_unavailable" feature is disabled

  @javascript
  Scenario: Does not allow user select fast making with a custom color
    # Allow express making for normal colors
    When I am on "Connie" dress page
    Then I select "USA" site version
    And I select the "Black" color
    And I select the express making option checkbox
    Then I should see "$319"
    # Auto deselects express making when custom color is selected
    And I select the "Burgundy" color
    Then I should see the express making option disabled
    Then I should see "$305"

  @javascript
  Scenario: Adds an express making product to the cart with the right price
    When I am on "Connie" dress page
    Then I select "USA" site version
    And I select "US 10" size
    And I select "58" inch height
    And I save the profile
    And I select the express making option checkbox
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I should see "Order Total$319.00"
