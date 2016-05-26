Feature: Contact Form

  Background:
    Given A sample database with valid data

  Scenario: Create new moodboard
    When I am on the homepage
    And I click on "Contact Us" link
    And I fill in form fields with:
      | First name   | John                       |
      | Last name    | Doe                        |
      | Email        | johndoe@gmail.com          |
      | Phone        | 1234567                    |
      | Your enquiry | Lorem Ipsum Dolor Sit Amet |
    And I click on "submit" button
    Then I should see "Thanks!"
    Then I should see "We won't play hard to get, we'll get back to you ASAP."
