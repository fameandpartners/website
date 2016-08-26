Feature: Browse and Purchase

  Background:
    Given A sample database with valid data
    And Data is setup correctly

  @javascript
  Scenario: Search For Dresses
    When I visit the "/" path
    And Search for "Non Existing Dress"
    Then I should see "We couldn't find the stuff you were looking for."
    And Search for "Connie"
    Then I should see "Results for"
    # Regression test for: https://github.com/fameandpartners/website/pull/1637
    And Search for an empty string
    Then I should see "Results for"

  Scenario: List All Lookbooks
    When I visit the "/lookbook" path
    Then I should see "It Girl Collection"
    Then I should see "Wedding & Parties"
    Then I should see "Fresh Collection"
    Then I should see "The Ruffled Up Collection"
    Then I should see "Partners In Crime"
    Then I should see "Just The Girls"
    Then I should see "Love Lace"

  Scenario: Show Filters on Dresses List
    When I visit the dresses page
    Then I should see "View all prices"
    Then I should see "$0 - $199"
    Then I should see "$200 - $299"
    Then I should see "$300 - $399"
