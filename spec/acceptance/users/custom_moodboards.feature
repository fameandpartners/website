Feature: Custom Moodboard
  Background:
    Given A sample database with valid data
      And Data is setup correctly
      And the "moodboard" feature is enabled
      And the "enhanced_moodboards" feature is enabled
      And The example user is signed in

  Scenario: Create new moodboard
    When I view my moodboard
    Then I should see "Create New Moodboard"
