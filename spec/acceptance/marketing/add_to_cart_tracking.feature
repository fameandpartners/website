Feature: Add to Cart Tracking

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags
    And The "test_analytics" feature is disabled
    And The "google_tag_manager" feature is enabled

  @javascript @selenium
  Scenario: Buy a Dress
    When I am on Connie dress page
    And I select "US 2" size
    And I select "Petite" skirt length
    Then I should see an active "ADD TO BAG" link
    And I click on "ADD TO BAG" link
    And I should see "Secure checkout"
    Then Page should have dataLayer "addToCart" event
    Then Page should have dataLayer "Connie" product
    Then Page should have dataLayer "4B453US2AU6C25" SKU from a variant
