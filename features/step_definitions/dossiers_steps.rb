# encoding: utf-8
When /^I add a new dossier$/ do
  visit new_dossier_path
  fill_in I18n.t("activerecord.attributes.dossier.code"), :with => "LY1101001"
  fill_in I18n.t("activerecord.attributes.dossier.name"), :with => "Martin"
  fill_in I18n.t("activerecord.attributes.dossier.date_appel"), :with => "31/01/2001"
  expect do
    click_button I18n.t('helpers.submit.create', :model => Dossier)
  end.to change{Dossier.count}.by(1)
  Dossier.last.user_id.should == @user.id
  Dossier.last.centre_id.should == @centre.id
end

Then /^I should see the page for my newly created dossier$/ do
  page.should have_content "Dossier créé(e) avec succès."
  page.should have_content "Dossier #LY1101001"
  page.should have_content "Martin"
  page.should have_content "31/01/2001"
end

Given /^an existing dossier$/ do
  @dossier = @centre.dossiers.build(
        :name => "dupont",
        :date_appel => "31/1/2011")
  @dossier.user_id = @user.id
  @dossier.save!
  visit dossier_path(@dossier)
end

When /^I update the dossier with new data$/ do
  click_link I18n.t('actions.edit')
  fill_in I18n.t("activerecord.attributes.dossier.name"), :with => "Dupont"
  fill_in I18n.t("activerecord.attributes.dossier.date_appel"), :with => "01/01/2001"
  click_button I18n.t('helpers.submit.update', :model => Dossier)
end

Then /^I should see the updated dossier$/ do
  page.should have_content "Dossier mis(e) à jour avec succès."
  page.should have_content "Dupont"
  page.should have_content "01/01/2001"
end

Given /^(\d+) dossiers exist$/ do |count|
  (1..count.to_i).each do |i|
    dossier = @centre.dossiers.build(
      :name => "name#{i}",
      :code => "LY11#{i}",
      :date_appel => "31/1/2011"
    )
    dossier.user_id = @user.id
    dossier.save!
  end
end

Given /^no dossiers exist with code "([^"]*)"$/ do |code|
  Dossier.find_by_code(code).should be_nil
end

Then /^I should see the page for creating a new dossier$/ do
  page.should have_content("Nouveau Dossier")
end

Then /^the code field should be pre\-filled with "([^"]*)"$/ do |code|
  page.should have_field('Numero Appel', with: code)
end

When /^I fill in the search field with "([^"]*)"$/ do |search|
  fill_in "dossier_code", :with => search
end

Then /^the search field should contain "([^"]*)"$/ do |value|
  find_field("dossier_code").value.should include(value)
end

When /^I submit$/ do
  click_button "OK"
end

Then /^I should see the page for the dossier with code "([^"]*)"$/ do |code|
  visit dossier_path(code)
  page.should have_content code
end
