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
  Then "I press \"Connexion\""
end

When(/I login with "(.*)"/) do |username|
  steps %Q{
    When I visit the authentication page
    When I fill in "username" with "#{username}"
    When I fill in "password" with "password"
    When I press the authenticate button
  }
end

When /^I (?:am logged in|login|log in) as an? #{capture_model}$/ do |role|
  Given "a #{role} exists"
  user = create_model(role)
  steps %Q{
    And I am not authenticated
    When I login with "#{user.username}"
    Then I should see a "sessions.logged_in" message
  }
end
