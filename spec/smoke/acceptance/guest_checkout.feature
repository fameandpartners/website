@javascript
Feature: Guest Checkout

  Background:
#    Given I am testing against production
    Given I am testing against localhost
    And I am on the homepage

  Scenario: Buy a Dress
    When I click on 'Shop'
#    And screenshot
    When I click on 'Prom Dresses'
#    And screenshot
    When I view dress 'Coco'
#    And screenshot
    When I choose size '8'
#    And screenshot
    And I add the dress to my cart
    And I click on 'Checkout'
    Then I should see 'EXISTING CUSTOMERS LOG IN'
    And screenshot
    When I fill the details:
      | field          | value                               |
      | First Name     | Smoky                               |
      | Last Name      | Tester                              |
      | Email          | dev+smoke-tests@fameandpartners.com |
      | Street Address | 123 Main St                         |
      | City           | Tester                              |
      | Phone          | 555 123 456                         |
      | Zipcode        | 55090                               |
      | Customer notes | Please make it good.                |
    And screenshot
    And I select 'United States' from 'Country *'
    And I select 'California' from 'State'


    #    And pry
#    When


#    And pry
#    And I click on the "Pretty Lace" dress
#    Then I should see "CONTENTCONTENTCONTENT"

  ## Custom PhantomJS release for Yosemite
# https://github.com/eugene1g/phantomjs/releases


#    dev+smoke-tests@fameandpartners.com
  # password
