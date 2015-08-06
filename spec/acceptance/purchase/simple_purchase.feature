Feature: Simple Purchase
  Background:
#    Given all production products are loaded
#    Given there is a "Pretty Lace" dress
    Given there is a default page
    Given there is a "Pretty Lace" dress
      And I am on the homepage

  @javascript
  Scenario: Buy a Dress
    When I click on 'Search'
      And I visit the first product
#     And I click on 'View all dresses'
     And screenshot
     And pry
     And I click on the "Pretty Lace" dress
    Then I should see "CONTENTCONTENTCONTENT"
