Given /^a user has an account$/ do
  steps %Q{
    Given a user exists with username: "username", password: "password", email: "myuser@example.com", centre: the centre, role: "centre_admin"
  }
end

When /^I logout$/ do
  steps %Q{
    Given I am not authenticated
  }
end

Given(/^I am not authenticated$/) do
  visit('/logout')
end

When(/authentication page$/) do
  visit('/login')
end

When(/enter the (.*) "(.*)"$/) do |field, value|
  steps %Q{
    When I fill in "#{field}" with "#{value}"
  }
end

When(/press the authenticate button$/) do
  steps %Q{
    Then I press "#{I18n.t('devise.shared.sign_in')}"
  }
end

When(/I login with "(.*)"/) do |username|
  steps %Q{
    When I visit the authentication page
    When I fill in "user_username" with "#{username}"
    When I fill in "user_password" with "password"
    When I press the authenticate button
  }
end

When /^the user logs in$/ do
    #Given a user exists with username: "myuser", password: "mypass", email: "myuser@example.com", centre: the centre, role: "centre_admin"
  steps %Q{
    When I login with "username"
  }
end

When /should see a success message$/ do
  steps %Q{
    Then I should see a "devise.sessions.signed_in" message
  }
end

Then /^they should not see a success message$/ do
  pending # express the regexp above with the code you wish you had
end
