Feature: Complete Guest Checkout (Paying with Afterpay)

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags

  # Note: VCR is recording Afterpay interaction!
  @javascript @vcr @shorter_cassette_names @selenium
  Scenario Outline: Successfully Buy a Dress
    Given The "afterpay" feature is enabled
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Dress Size>" size
    And I select "<Skirt Length>" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "<Country>" country and "<State>" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Street Address          | Street X                         |
      | Street Address (cont'd) | House Y                          |
      | City                    | Melbourne                        |
      | Phone Number            | 2255-4422                        |
      | <Zipcode Label>         | 12345                            |
    And I click on "Pay Securely" button
    And I click on "Continue With Afterpay" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | name       | Roger That                       |
      | address1   | Street X                         |
      | suburb     | Suburb                           |
      | state      | State                            |
      | postcode   | 1234                             |
      | cardName   | Roger That                       |
      | cardNumber | 5520000000000000                 |
      | expiryDate | 0230                             |
      | cardCVC    | 123                              |
    Then I should see my order placed, with "Connie" dress, "<Dress Size>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country   | State      | Zipcode Label | Dress Size | Skirt Length | Dress Price |
      | Australia    | Australia | Queensland | Postcode      | AU 14      | Petite       | 319.00      |

  # Note: VCR is recording Afterpay interaction!
  @javascript @vcr @shorter_cassette_names @selenium
  Scenario Outline: Afterpay cannot process user payment, user sees an error
    Given The "afterpay" feature is enabled
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Dress Size>" size
    And I select "<Skirt Length>" skirt length
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "<Country>" country and "<State>" state
    And I fill in form fields with:
      | Email                   | firefox_user@fameandpartners.com |
      | First Name              | Roger                            |
      | Last Name               | That                             |
      | Street Address          | Street X                         |
      | Street Address (cont'd) | House Y                          |
      | City                    | Melbourne                        |
      | Phone Number            | 2255-4422                        |
      | <Zipcode Label>         | 12345                            |
    And I click on "Pay Securely" button
    And I click on "Continue With Afterpay" link
    Then I fill in Afterpay data within its iframe:
      | email      | firefox_user@fameandpartners.com |
      | password   | firefox1                         |
      | name       | Roger That                       |
      | address1   | Street X                         |
      | suburb     | Suburb                           |
      | state      | State                            |
      | postcode   | 1234                             |
      | cardName   | Roger That                       |
      | cardNumber | 5520000000000000                 |
      | expiryDate | 0230                             |
      | cardCVC    | 123                              |
    Then I should see "Afterpay payment failed, please try again later."

    Examples:
      | Site Version | Country   | State      | Zipcode Label | Dress Size | Skirt Length | Dress Price |
      | Australia    | Australia | Queensland | Postcode      | AU 14      | Petite       | 319.00      |
