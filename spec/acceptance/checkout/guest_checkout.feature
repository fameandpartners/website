Feature: Complete Guest Checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags

  @javascript @no_vcr
  Scenario Outline: User Validation Errors
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Dress Size>" size
    And I select "<Skirt Length>" skirt length
    And I click on "Add to Cart" button
    # And I should see the cart sidebar with the checkout button
    # And I click on "CHECKOUT" button
    Then I fill in form fields with blank spaces:
      | First Name |
      | Last Name  |
    And I fill in form fields with:
      | Email                   | invalid-email |
      | Street Address          | Street X      |
      | Street Address (cont'd) | House Y       |
      | City                    | Melbourne     |
      | Phone Number            | 2255-4422     |
      | <Zipcode Label>         | 12345         |
    And I select "<State>" state
    And I select "<Country>" country
    And I click on "Pay Securely" button
    Then I should see "Customer E-Mail is invalid"
    Then I should see "First name can't be blank"
    Then I should see "Last name can't be blank"
    Examples:
      | Site Version | Country       | State      | Zipcode Label | Dress Size | Skirt Length |
      | Australia    | Australia     | Queensland | Postcode      | AU 14      | Petite       |
      | USA          | United States | California | Zipcode       | US 10      | Petite       |

  # TODO: Payment step require connection to PIN payment method. This should be recorded by VCR, not ignored.
  @javascript @no_vcr
  Scenario Outline: Successfully Buy a Dress
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Dress Size>" size
    And I select "<Skirt Length>" skirt length
    And I click on "Add to Cart" button
    # And I should see the cart sidebar with the checkout button
    # And I click on "CHECKOUT" button
    Then I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Street Address          | Street X       |
      | Street Address (cont'd) | House Y        |
      | City                    | Melbourne      |
      | Phone Number            | 2255-4422      |
      | <Zipcode Label>         | 12345          |
    And I select "<State>" state
    And I select "<Country>" country
    And I click on "Pay Securely" button
    Then I should see "ADDITIONAL CUSTOM DUTY FEES MAY APPLY"
    And I click on "OK" button
    And I fill in credit card information:
      | Card number      | 5520000000000000  |
      | Name on card     | Zaphod Beeblebrox |
      | CVC              | 123               |
      | Expiration Month | 10                |
      | Expiration Year  | 2050              |
    And I click on "Place My Order" button
    Then I should see my order placed, with "Connie" dress, "<Dress Size>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country       | State      | Zipcode Label | Dress Size | Skirt Length | Dress Price |
      | Australia    | Australia     | Queensland | Postcode      | AU 14      | Petite       | 319.00      |
      | USA          | United States | California | Zipcode       | US 10      | Petite       | 289.00      |
