Feature: Add to Moodboard
  Background:
    Given A sample database with valid data
      And Data is setup correctly
      And the moodboard feature is enabled

  @javascript
  Scenario:
   Given The example user is signed in
     And I visit the dresses page
    Then I should see "+moodboard"
    When I add "Connie" to my moodboard
    Then I should have "Connie" on my moodboard
