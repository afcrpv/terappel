When /^I fill in the email field with "([^"]*)"$/ do |email|
  fill_in I18n.t('sessions.password_resets.email'), :with => email
end

When /^I press the reset password button$/ do
  click_button I18n.t('sessions.password_resets.reset_password')
end

When /^I follow the change password link in the email$/ do
  steps %Q{
    When I click the first link in the email
  }
end

When /^I fill in the password field with "([^"]*)"$/ do |password|
  steps %Q{
    When I fill in "#{I18n.t('sessions.new.password')}" with "#{password}"
  }
end

When /^I fill in the password confirmation field with "([^"]*)"$/ do |confirmation|
  steps %Q{
    When I fill in "#{I18n.t('sessions.password_resets.password_confirmation')}" with "#{confirmation}"
  }
end

When /^I press the change password button$/ do
  steps %Q{
    When I press "#{I18n.t('sessions.password_resets.submit')}"
  }
end
