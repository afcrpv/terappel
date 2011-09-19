Feature: testing user authentication
  In order to restrict write access to authorized users
  A user
  Should authenticate themselves to the application
  To avoid wasting time

  Scenario Outline: user tries to authenticate
    Given a user exists with username: "myuser", password: "mypass", email: "myuser@example.com"
    When I visit the user authentication page
    And I enter the username "<username>"
    And I enter the password "<password>"
    And I press the authenticate button
    Then I should <expectation> a "sessions.logged_in" message
    Examples:
      | username  | password  | expectation |
      | myuser    | mypass    | see         |
      | tizio     | pass      | not see     |

  Scenario: log out
    When I login with "username"
    And I logout
    Then I should see a "sessions.new.login" message
