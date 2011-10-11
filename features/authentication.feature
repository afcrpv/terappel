Feature: testing user authentication
  In order to restrict write access to authorized users
  A user
  Should authenticate themselves to the application
  To avoid wasting time

  Background:
    Given a centre exists
    And a user has an account

  Scenario: user authenticates successfully
    When the user logs in
    Then they should see a success message

  Scenario: user is denied access
