#Feature: Custom Height Selection
#
#  Background:
#    Given A sample database with valid data
#    And the "height_customisation" feature is enabled
#    And Data is setup correctly
#
#
#  @pending @javascript
#  Scenario Outline: Buy a Dress
#    When I am on Connie dress page
#    Then I select "<Site Version>" site version
#    And I select "<Dress Size>" size
#    And I select "<Height>" height
#    And I click on "Add to Cart" button
#    And I should see the cart sidebar with the checkout button
#    And open screenshot
#    And I click on "CHECKOUT" button
#
#    Examples:
#      | Site Version | Country   | State      | Zipcode Label | Dress Size | Dress Price | Height   |
#      | Australia    | Australia | Queensland | Postcode      | AU 14      | 319.00      | Tall     |
