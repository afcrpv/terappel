When /^I follow the forgot password link$/ do
  steps %Q{
    When I follow "#{I18n.t('devise.shared.forgot_password')}"
  }
end

When /^I fill in the email field with "([^"]*)"$/ do |email|
  fill_in 'user_email', :with => email
end

When /^I press the reset password button$/ do
  click_button I18n.t('devise.passwords.send_reset_password_instructions')
end

When /^I follow the change password link in the email$/ do
  steps %Q{
    When I click the first link in the email
  }
end

When /^I fill in the password field with "([^"]*)"$/ do |password|
  steps %Q{
    When I fill in "#{I18n.t('devise.passwords.new_password')}" with "#{password}"
  }
end

When /^I fill in the password confirmation field with "([^"]*)"$/ do |confirmation|
  steps %Q{
    When I fill in "#{I18n.t('devise.passwords.confirm_new_password')}" with "#{confirmation}"
  }
end

When /^I press the change password button$/ do
  steps %Q{
    When I press "#{I18n.t('devise.passwords.change_my_password')}"
  }
end
