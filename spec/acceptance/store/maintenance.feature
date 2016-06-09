Feature: Maintenance Feature Flag
  Scenario: Website is not on maintenace
    When The "maintenance" feature is disabled
    And I visit the "/" path
    And I should see "LUXE DRESSES FOR EVERY OCCASION"

  Scenario: Website is on maintenace
    When The "maintenance" feature is enabled
    And I visit the "/" path
    And I should see "We're just Getting Changed..."
