Feature: Manage centre users
  In order to allow other centre users to add data to terappel
  As a terappel centre admin
  I want to be able to manage users

  Background:
    Given a centre admin is logged in

  Scenario: add new user
    When I add a new centre user
    Then I should see the page for this newly created user

  Scenario: update existing user
    Given an existing centre user
    When I update the user with new data
    Then I should see the updated user

  @javascript
  Scenario: remove existing user
    Given an existing centre user
    When I press the destroy button
    Then the user should be destroyed
