# encoding: utf-8
Given /^I go to the new dossier page with code "([^\"]*)"$/ do |code|
  visit new_dossier_path(code: "#{code}") # express the regexp above with the code you wish you had
end

When /^I add a new dossier$/ do
  step %{I go to the new dossier page with code "LY1101001"}
  find(:css, "#dossier_date_appel").set "31/01/2001"
  find(:css, "#dossier_name").set "Martin"
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
  find(:css, "#dossier_date_appel").set "01/01/2001"
  find(:css, "#dossier_name").set "Dupont"
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
  page.find(:css, '#dossier_code').value.should == code
end

When /^I fill in the search field with "([^"]*)"$/ do |search|
  fill_in "codedossier", :with => search
end

Then /^the search field should contain "([^"]*)"$/ do |value|
  find_field("codedossier").value.should include(value)
end

Given /^a correspondant from same user centre$/ do
  corr = Factory(:correspondant, centre: @user.centre)
  corr.centre.should === @user.centre
end

Given /^a correspondant from centre "([^"]*)"$/ do |centre_name|
  centre = Factory(:centre, name: centre_name)
  Factory(:correspondant, centre: centre, ville: centre_name)
  Correspondant.find_by_ville(centre_name).should_not be_nil
end

Then /^the correspondants list should (contain|not contain) "([^"]*)"$/ do |condition, text|
  check = condition == "contain" ? true : false
  page.execute_script %Q{ $('input[data-autocomplete]').trigger("focus") }
  page.execute_script %Q{ $('input[data-autocomplete]').trigger("keydown") }
  sleep 1
  page.has_content?(text).should == check
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
  page.should have_content "Modification Dossier ##{code}"
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

Then /^the modify correspondant button should be visible$/ do
  page.find(:css, "a.edit-correspondant").visible?.should == true
end

When /^I calculate the dates grossesse$/ do
  click_on "Grossesse"
  click_on "Calculer"
end

Then /^I should see "([^"]*)"$/ do |message|
  page.should have_content(message)
end

When /^I fill in the date appel field with "([^"]*)"$/ do |date|
  find(:css, "#dossier_date_appel").set date
end

When /^I fill in the date debut grossesse field with "([^"]*)"$/ do |date|
  click_on "Grossesse"
  fill_in "dossier_date_debut_grossesse", with: date
end

Then /^the date accouchement prevue should be "([^"]*)"$/ do |date|
  find(:css, 'input#dossier_date_accouchement_prevu').value.should == date
end

When /^I fill in the date dernieres regles field with "([^"]*)"$/ do |date|
  click_on "Grossesse"
  fill_in "dossier_date_dernieres_regles", with: date
end

Then /^the age grossesse should be "([^"]*)"$/ do |sa|
  find(:css, 'input#dossier_age_grossesse').value.should == sa
end

Then /^the date debut grossesse should be "([^"]*)"$/ do |date|
  find(:css, 'input#dossier_date_debut_grossesse').value.should == date
end

When /^I choose "([^"]*)" as the evolution$/ do |evolution|
  click_on "Evolution"
  choose evolution
end

Then /^the mod accouch input should (be|not be) visible$/ do |condition|
  check = condition == "be" ? true : false
  find(:css, '#modaccouch').visible?.should == check
end

Given /^the evolutions "([^"]*)"$/ do |evolutions|
  evolutions.split(" ").each do |evolution|
    Factory(:evolution, name: evolution)
  end
end
