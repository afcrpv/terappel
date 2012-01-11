# encoding: utf-8
Given /^I go to the new dossier page with code "([^\"]*)"$/ do |code|
  visit new_dossier_path(code: "#{code}") # express the regexp above with the code you wish you had
end

When /^I add a new dossier$/ do
  step %{I go to the new dossier page with code "LY1101001"}
  fill_in "Date Appel", :with => "31/01/2001"
  fill_in "Nom patiente", :with => "Martin"
  expect do
    click_button I18n.t('helpers.submit.create')
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
        :code => "LY1111001",
        :date_appel => "31/1/2011")
  @dossier.user_id = @user.id
  @dossier.save!
  visit dossier_path(@dossier)
end

When /^I update the dossier with new data$/ do
  visit edit_dossier_path(@dossier)
  fill_in I18n.t("activerecord.attributes.dossier.name"), :with => "Dupont"
  fill_in I18n.t("activerecord.attributes.dossier.date_appel"), :with => "01/01/2001"
  click_button I18n.t('helpers.submit.update')
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

When /^I fill in the correspondant field with "([^"]*)"$/ do |value|
  fill_in "dossier_correspondant_nom", :with => value
end

Then /^the correspondant field should contain "([^"]*)"$/ do |value|
  find_field("dossier_correspondant_nom").value.should include(value)
end

Given /^(\d+) correspondants exist$/ do |count|
  count.to_i.times do
    Factory(:correspondant)
  end
end

When /^I submit$/ do
  click_on "OK"
end

Then /^I should see the page for the dossier with code "([^"]*)"$/ do |code|
  visit dossier_path(code)
  page.should have_content code
end

When /^I press the destroy button$/ do
  click_on "Détruire"
  dialog = page.driver.browser.switch_to.alert
  dialog.text.should == "Etes-vous sûr ?"
  dialog.accept
end

Then /^the ([^"]*) should be destroyed$/ do |resource|
  page.should have_content "#{resource.humanize} détruit(e) avec succès"
end
