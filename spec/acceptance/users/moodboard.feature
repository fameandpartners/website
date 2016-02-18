# Requires JS for the AJAX add to moodboard
@javascript
Feature: Add to Moodboard

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And The "moodboard" feature is enabled
    And The "enhanced_moodboards" feature is enabled
    And The example user is signed in

  Scenario: Add to moodboard
    When I visit the dresses page
    Then I should see "+moodboard"
    And I add "Connie" to my moodboard
    Then I should see the dress added to the moodboard
    Then I should have "Connie" on my moodboard

  Scenario: Remove from Moodboard
    When I visit the dresses page
    Then I should see "+moodboard"
    And I add "Connie" to my moodboard
    Then I should see the dress added to the moodboard
    Then I should have "Connie" on my moodboard
    When I remove "Connie" from my moodboard
     # The extra page view is required here, as the dummy text
     # does not display after all ajax deletions.
    Then I view my moodboard
    Then I should see "GET INSPIRED!"
