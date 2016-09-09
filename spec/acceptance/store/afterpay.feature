Feature: Information about Afterpay on Australian website

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And The "afterpay" feature is enabled

  Scenario: See Afterpay FAQ on Australian website
    When I visit the "/faqs" path
    And I select "Australia" site version
    Then I should see "What is Afterpay?"
    And I select "USA" site version
    Then I should not see "What is Afterpay?"
