Feature: reset password
  In order to recover lost passwords
  A user
  Should be able to access a reset password form

  Background:

  Scenario: password request for an unknow user
    When an unknown user asks for a new password
    Then they should not receive an email

  Scenario: change password through email link
    Given a user belonging to an existing centre
    When they ask for a new password
    Then they should receive an email

    When they follow the change password link in the email
    And they enter a new password
    Then their password should be updated
