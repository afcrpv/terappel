Feature: testing user authentication
  In order to restrict write access to authorized users
  A user
  Should authenticate themselves to the application
  To avoid wasting time

  Background:
    Given a user belonging to an existing centre

  Scenario: user authenticates successfully
    When the user logs in with correct credentials
    Then they should see a success message

  Scenario: user is denied access
    When the user logs in with wrong credentials
    Then they should be denied access
