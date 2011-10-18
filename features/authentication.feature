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

  Scenario: user can access his profile
    When the user goes to his profile page
    Then they should see their personal informations

  Scenario: user edits his profile
    When the user edits his profile informations
    Then they should see their updated profile

  Scenario: user tries to change his password without filling in current password
    When the user changes his password without filling the current password
    Then their password shouldn't change

  Scenario: user changes his password
    When the user changes his password
    Then they should be able to reconnect with the changed password
