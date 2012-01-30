When /^they ask for a new password$/ do
  request_password(@user, @user.email)
  page.should have_content I18n.t("devise.passwords.send_instructions")
end

Then /^they should receive an email$/ do
  emails.last.to.should include(@user.email)
end

When /^an unknown user asks for a new password$/ do
  request_password(Factory(:user), "wrong@domain.com")
end

Then /^they should not receive an email$/ do
  emails.last.should be_nil
end

When /^they follow the change password link in the email$/ do
  click_first_link_in_email(emails.last)
end

When /^they enter a new password$/ do
  fill_in "#{I18n.t('devise.passwords.new_password')}", :with => "newpass"
  fill_in "#{I18n.t('devise.passwords.confirm_new_password')}", :with => "newpass"
  click_button "#{I18n.t('devise.passwords.change_my_password')}"
end

Then /^their password should be updated$/ do
  page.should have_content I18n.t("devise.passwords.updated")
end
