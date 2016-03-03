@javascript
Feature: Welcome Modal
  Background:
    Given The "marketing_modals" feature is enabled

  Scenario: Show welcome modal (only once)
    When I visit the "/" path
    Then I should see "RUNWAY STYLES AT A FRACTION OF THE PRICE"
    Then I visit the "/" path
    Then I should not see "RUNWAY STYLES AT A FRACTION OF THE PRICE"

  Scenario: Do not show welcome modal (when promocode param applied)
    When I visit the "/?pc=something" path
    Then I should not see "RUNWAY STYLES AT A FRACTION OF THE PRICE"

  Scenario: Do not show welcome modal (when explicitly hidden by param)
    When I visit the "/?hwm=true" path
    Then I should not see "RUNWAY STYLES AT A FRACTION OF THE PRICE"
