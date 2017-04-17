Feature: Afterpay on Australian's Website Storefront

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And The "afterpay" feature is enabled

  @javascript
  Scenario: See Afterpay modal on PDP page
    When I am on Connie dress page
    And I select "Australia" site version
    Then I should see "or 4 easy payments of $79.75 with"
    And I click on element with text "info"
    Then I should see "Just select Afterpay at checkout"
    And I click on "Close Menu" link
    When I select "USA" site version
    Then I should not see "or 4 easy payments of $79.75 with"

  Scenario: See Afterpay FAQ information
    When I visit the "/faqs" path
    And I select "Australia" site version
    Then I should see "What is Afterpay?"
    And I select "USA" site version
    Then I should not see "What is Afterpay?"
