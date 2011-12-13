Given /^a user belonging to an existing centre$/ do
  @centre = Centre.create!(:name => "lyon", :code => "ly")
  @user = @centre.users.create!(
    :username => "username",
    :password => "password",
    :email => "myuser@example.com")
end

When /^the user logs in with correct credentials$/ do
  login(@user.username, @user.password)
end

When /^the user logs in with wrong credentials$/ do
  login("wronguser", "wrongpassword")
end

Given /^a centre admin is logged in$/ do
  steps %Q{
    Given a user belonging to an existing centre
    When the user logs in with correct credentials
  }
  @user.role ="centre_admin"
  @user.save!
end

When /should see a success message$/ do
  steps %Q{
    Then I should see a "devise.sessions.signed_in" message
  }
end

Then /^they should be denied access$/ do
  steps %Q{
    Then I should see a "devise.failure.invalid" message
  }
end

When /^the user goes to his profile page$/ do
  steps %Q{
    When the user logs in with correct credentials
  }
  visit user_path(@user)
end

Then /^they should see their personal informations$/ do
  page.should have_content @user.username
  page.should have_content @user.email
  page.should have_content @user.centre_name
  page.should have_content @user.role
end

When /^the user edits his profile informations$/ do
  steps %Q{
    When the user logs in with correct credentials
  }
  visit edit_user_path(@user)
  fill_in I18n.t("activerecord.attributes.user.username"), :with => "utilisateur"
  fill_in I18n.t("activerecord.attributes.user.email"), :with => "utilisateur@test.com"
  click_on I18n.t('formtastic.actions.update_profile')
end

Then /^they should see their updated profile$/ do
  page.should have_content "utilisateur"
  page.should have_content "utilisateur@test.com"
end

When /^the user changes his password without filling the current password$/ do
  steps %Q{
    When the user logs in with correct credentials
  }
  visit edit_user_path(@user)
  fill_in I18n.t("activerecord.attributes.user.password"), :with => "newpassword"
  fill_in I18n.t("activerecord.attributes.user.password_confirmation"), :with => "newpassword"
end

Then /^their password shouldn't change$/ do
  expect do
    click_on I18n.t('formtastic.actions.update_profile')
  end.to_not change{@user.password}
end

When /^the user changes his password$/ do
  steps %Q{
    When the user logs in with correct credentials
  }
  visit edit_user_path(@user)
  fill_in I18n.t("activerecord.attributes.user.current_password"),
    :with => "password"
  fill_in I18n.t("formtastic.labels.user.edit.password"),
    :with => "newpassword"
  fill_in I18n.t("activerecord.attributes.user.password_confirmation"),
    :with => "newpassword"
  click_on I18n.t('formtastic.actions.update_profile')
end

Then /^they should be able to reconnect with the changed password$/ do
  page.should have_content I18n.t('devise.failure.unauthenticated')
  login(@user.username, "newpassword")
  page.should have_content I18n.t('devise.sessions.signed_in')
end
