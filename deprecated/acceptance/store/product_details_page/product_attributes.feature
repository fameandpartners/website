Feature: PDP's attributes

  Background:
    Given A sample database with valid data

  # Regression for https://fameandpartners.atlassian.net/browse/WEBSITE-989
  @javascript
  Scenario: Preselect custom color when visiting PDP
    # Visit PDP without query string
    When I visit the "/dresses/dress-connie-681" path
    Then I see the "Black" color selected
    # Visit PDP with custom color query string
    When I visit the "/dresses/dress-connie-681?color=burgundy" path
    Then I see the "Burgundy" color selected
    # Visit PDP with non-existent color query string
    When I visit the "/dresses/dress-connie-681?color=nothing" path
    Then I see no color selected
