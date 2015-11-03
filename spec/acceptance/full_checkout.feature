Feature: Full checkout

  Background:
    Given A sample database with valid data
    And Data is setup correctly

  @javascript @no_vcr
  Scenario Outline: Buy a Dress
    When I am on Connie dress page
    Then I select "<Site Version>" site version
    And I select "<Dress Size>" size
    And I click on "Add to Cart" button
    And I should see the cart sidebar with the checkout button
    And I click on "CHECKOUT" button
    Then I fill in form fields with:
      | Email                   | my@email.com |
      | First Name              | Roger        |
      | Last Name               | That         |
      | Street Address          | Street X     |
      | Street Address (cont'd) | House Y      |
      | City                    | Melbourne    |
      | Phone Number            | 2255-4422    |
      | <Zipcode Label>         | 12345        |
    And I select "<State>" state
    And I select "<Country>" country
    And I click on "Pay Securely" button
    And I fill in credit card information:
      | Card number      | 5520000000000000  |
      | Name on card     | Zaphod Beeblebrox |
      | CVC              | 123               |
      | Expiration Month | 10                |
      | Expiration Year  | 2050              |
    And I click on "Place My Order" button
    Then I should see my order placed, with "Connie" dress, "<Dress Size>" size and "<Dress Price>" price

    Examples:
      | Site Version | Country       | State      | Zipcode Label | Dress Size | Dress Price |
      | Australia    | Australia     | Queensland | Postcode      | AU 14      | 255.20      |
      | USA          | United States | California | Zipcode       | US 10      | 231.20      |
