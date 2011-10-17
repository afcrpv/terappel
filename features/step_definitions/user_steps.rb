#encoding: utf-8
When /^I add a new centre user$/ do
  visit new_centre_user_path(@centre)
  fill_in I18n.t("activerecord.attributes.user.username"), :with => "auser"
  fill_in I18n.t("activerecord.attributes.user.email"), :with => "auser@gmail.com"
  fill_in I18n.t("activerecord.attributes.user.password"), :with => "motdepasse"
  fill_in I18n.t("activerecord.attributes.user.password_confirmation"), :with => "motdepasse"
  expect do
    click_button I18n.t('helpers.submit.create', :model => I18n.t("activerecord.models.user"))
  end.to change{User.count}.by(1)
  User.last.role.should == "centre_user"
end

Then /^I should see the page for this newly created user$/ do
  page.should have_content "Utilisateur créé(e) avec succès."
  page.should have_content "auser"
end

Given /^an existing centre user$/ do
  user = @centre.users.create!(
    :username => "centeruser",
    :password => "password",
    :email => "centeruser@example.com")
  user.update_attribute(:role,"centre_user")
  visit centre_user_path @centre, user
end

When /^I update the user with new data$/ do
  click_link I18n.t('actions.edit')
  fill_in I18n.t("activerecord.attributes.user.username"), :with => "autreuser"
  fill_in I18n.t("activerecord.attributes.user.current_password"), :with => "password"
  click_button I18n.t('helpers.submit.update', :model => I18n.t("activerecord.models.user"))
end

Then /^I should see the updated user$/ do
  page.should have_content "Utilisateur mis(e) à jour avec succès."
  page.should have_content "autreuser"
end
