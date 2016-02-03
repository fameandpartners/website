Feature: Add to Cart Tracking

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And the "test_analytics" feature is disabled
    And the "google_tag_manager" feature is enabled

  @javascript @no_vcr
  Scenario: Buy a Dress
    When I am on Connie dress page
    And I select "US 2" size
    And I click on "Add to Cart" button
    And I should see "Secure checkout"
    Then Page should have dataLayer "addToCart" event
    Then Page should have dataLayer "Connie" product
