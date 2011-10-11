Feature: reset password
  In order to recover lost passwords
  A user
  Should be able to access a reset password form

  Background:
    Given all emails have been delivered
    And a centre exists
    And a user exists with username: "user", email: "user@example.com", centre: the centre

  Scenario Outline: password resets email sending
    When I visit the user authentication page
    And I follow the forgot password link
    And I fill in the email field with "<email>"
    And I press the reset password button
    Then I should <action> a "devise.passwords.send_instructions" message
    Then <count> email should be delivered to the user
    Examples:
      | email             |action| count |
      | user@example.com  | see  | 1     |
      | bidon@example.com | not see| 0     |

  Scenario: change password through email link
    When I visit the user authentication page
    And I follow the forgot password link
    And I fill in the email field with "user@example.com"
    And I press the reset password button
    Then 1 email should be delivered to the user
    When I follow the change password link in the email
    And I fill in the password field with "newpass"
    And I fill in the password confirmation field with "newpass"
    And I press the change password button
    Then I should see a "devise.passwords.updated" message
