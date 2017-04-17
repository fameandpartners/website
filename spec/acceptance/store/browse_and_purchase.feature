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

  @javascript
  Scenario: Show Filters on Dresses List
    When I visit the dresses page
    And DOM is ready for JS interaction
    Then I should see "All Prices"
    Then I click on element with text "All Prices"
    Then I should see "$0 - $199"
    Then I should see "$200 - $299"
    Then I should see "$300 - $399"
