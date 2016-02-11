Feature: Profile Page

  Background:
    Given A sample database with valid data
    And The example user is signed in

  Scenario: User Should See Profile Page
    When I visit my profile page
    Then I should see my first name as "Example"
    And I should see my last name as "User"
