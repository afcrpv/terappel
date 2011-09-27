Feature: reset password
  In order to recover lost passwords
  A user
  Should be able to access a reset password form

  Scenario: existing user
    Given all emails have been delivered
    And a user exists with username: "user", email: "user@example.com"
    When I visit the user authentication page
    And I fill in the email field with "user@example.com"
    And I press the reset password button
    Then I should see a "sessions.password_resets.instructions_sent" message
    Then 1 email should be delivered to the user
