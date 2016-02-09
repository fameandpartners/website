Feature: Visit the homepage

  Background:
    Given A sample database with valid data

  Scenario:
    When I am on the homepage
    Then I should see "LUXE DRESSES FOR EVERY OCCASION"
