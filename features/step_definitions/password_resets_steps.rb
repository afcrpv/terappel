When /^I fill in the email field with "([^"]*)"$/ do |email|
  fill_in I18n.t('sessions.password_resets.email'), :with => email
end

When /^I press the reset password button$/ do
  click_button I18n.t('sessions.password_resets.reset_password')
end
