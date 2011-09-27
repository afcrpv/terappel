Feature: reset password
  In order to recover lost passwords
  A user
  Should be able to access a reset password form

  Background:
    Given all emails have been delivered
    And a user exists with username: "user", email: "user@example.com"

  Scenario Outline: password resets email sending
    When I visit the user authentication page
    And I fill in the email field with "<email>"
    And I press the reset password button
    Then I should see a "sessions.password_resets.instructions_sent" message
    Then <count> email should be delivered to the user
    Examples:
      | email             | count |
      | user@example.com  | 1     |
      | bidon@example.com | 0     |

  Scenario: change password through email link
    When I visit the user authentication page
    And I fill in the email field with "user@example.com"
    And I press the reset password button
    Then 1 email should be delivered to the user
    When I follow the change password link in the email
    And I fill in the password field with "newpass"
    And I fill in the password confirmation field with "newpass"
    And I press the change password button
    Then I should see a "sessions.password_resets.password_updated" message
