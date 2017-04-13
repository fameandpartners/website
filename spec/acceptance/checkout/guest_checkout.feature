Feature: Complete Guest Checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly
    And Setup default feature flags

  @javascript @no_vcr
  Scenario Outline: User Validation Errors
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Size Profile>" size
    And I select "<Height Value>" skirt length
    And I save the profile
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I fill in form fields with blank spaces:
      | First Name |
      | Last Name  |
    And I fill in form fields with:
      | Email                   | invalid-email |
      | Address                 | Street X      |
      | Street Address (line 2) | House Y       |
      | City                    | Melbourne     |
      | Phone                   | 2255-4422     |
      | <Zipcode Label>         | 12345         |
    And I select "<State>" state
    And I select "<Country>" country
    And I click on "Continue to payment" button
    Then I should see "Customer E-Mail is invalid"
    Then I should see "First name can't be blank"
    Then I should see "Last name can't be blank"
    Examples:
      | Site Version | Country       | State      | Zipcode Label | Size Profile | Height Value |
      | Australia    | Australia     | Queensland | Postcode      | AU 14        | 152          |

  @javascript @no_vcr
  Scenario Outline: User Validation Errors
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Size Profile>" size
    And I select "<Height Value>" inch height
    And I save the profile
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I fill in form fields with blank spaces:
      | First Name |
      | Last Name  |
    And I fill in form fields with:
      | Email                   | invalid-email |
      | Address                 | Street X      |
      | Street Address (line 2) | House Y       |
      | City                    | Melbourne     |
      | Phone                   | 2255-4422     |
      | <Zipcode Label>         | 12345         |
    And I select "<State>" state
    And I select "<Country>" country
    And I click on "Continue to payment" button
    Then I should see "Customer E-Mail is invalid"
    Then I should see "First name can't be blank"
    Then I should see "Last name can't be blank"
    Examples:
      | Site Version | Country       | State      | Zipcode Label | Size Profile | Height Value |
      | USA          | United States | California | Zipcode       | US 10        | 58           |

  @javascript @no_vcr
  Scenario Outline: Successfully Buy a Dress and Ship To a Country With Custom Duty Feeds
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Size Profile>" size
    And I select "<Height Value>" inch height
    And I save the profile
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "<Country>" country and "<State>" state
    And I should see shipping to "<Country>" warning
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Address                 | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | <Zipcode Label>         | 12345          |
    Then I agree with shipping fee
    And I click on "Continue to payment" button
    And I should see "Shipping$30.00"
    And I click on "Credit Card" link
    And I fill in form fields with:
      | Name on your card | Zaphod Beeblebrox |
      | Card number       | 5520000000000000  |
      | month             | 10                |
      | year              | 2050              |
      | card_code         | 123               |
    And I click on "Place your order now" button
    Then I should see my order placed, with "Connie" dress, "<Size Profile>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country | State             | Zipcode Label | Size Profile | Height Value | Dress Price |
      | USA          | Germany | Baden-Württemberg | Zipcode       | US 10        | 58           | 289.00      |

  # VCR is disabled on full checkout acceptance specs since we can detect PIN payments breaking changes!
  @javascript @no_vcr
  Scenario Outline: Successfully Buy a Dress (with Credit Card - PIN Payment Method)
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Size Profile>" size
    And I select "<Height Value>" skirt length
    And I save the profile
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    #Then I click on "Continue to payment" button
    Then I select "<Country>" country and "<State>" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Address                 | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | <Zipcode Label>         | 12345          |
    And I agree with shipping fees if required
    And I click on "Continue to payment" button
    And I click on "Credit Card" link
    And I fill in form fields with:
      | Name on your card | Zaphod Beeblebrox |
      | Card number       | 5520000000000000  |
      | month             | 10                |
      | year              | 2050              |
      | card_code         | 123               |
    And I click on "Place your order now" button
    Then I should see my order placed, with "Connie" dress, "<Size Profile>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country       | State      | Zipcode Label | Size Profile | Height Value | Dress Price |
      | Australia    | Australia     | Queensland | Postcode      | AU 14        | 147          | 319.00      |
      | Australia    | New Zealand   | Whanganui  | Postcode      | AU 14        | 147          | 319.00      |

  # VCR is disabled on full checkout acceptance specs since we can detect PIN payments breaking changes!
  @javascript @no_vcr
  Scenario Outline: Successfully Buy a Dress (with Credit Card - PIN Payment Method)
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Size Profile>" size
    And I select "<Height Value>" inch height
    And I save the profile
    Then I should see add to cart link enabled
    And I click on "ADD TO BAG" link
    Then I select "<Country>" country and "<State>" state
    And I fill in form fields with:
      | Email                   | test@email.com |
      | First Name              | Roger          |
      | Last Name               | That           |
      | Address                 | Street X       |
      | Street Address (line 2) | House Y        |
      | City                    | Melbourne      |
      | Phone                   | 2255-4422      |
      | <Zipcode Label>         | 12345          |
    And I agree with shipping fees if required
    And I click on "Continue to payment" button
    And I click on "Credit Card" link
    And I fill in form fields with:
      | Name on your card | Zaphod Beeblebrox |
      | Card number       | 5520000000000000  |
      | month             | 10                |
      | year              | 2050              |
      | card_code         | 123               |
    And I click on "Place your order now" button
    Then I should see my order placed, with "Connie" dress, "<Size Profile>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country       | State      | Zipcode Label | Size Profile | Height Value | Dress Price |
      | USA          | United States | California | Zipcode       | US 10        | 58           | 289.00      |
