# encoding: utf-8
When /^I add a new dossier$/ do
  visit new_centre_dossier_path(@centre)
  fill_in I18n.t("activerecord.attributes.dossier.name"), :with => "Martin"
  fill_in I18n.t("activerecord.attributes.dossier.date_appel"), :with => "31/01/2001"
  click_button I18n.t('helpers.submit.create', :model => Dossier)
  Dossier.count.should == 1
end

Then /^I should see the page for my newly created dossier$/ do
  page.should have_content "Dossier créé(e) avec succès."
  page.should have_content "Dossier #LY-2001-1"
  page.should have_content "Martin"
  page.should have_content "31/01/2001"
end

Given /^an existing dossier$/ do
  @dossier = @centre.dossiers.create(
        :name => "dupont",
        :date_appel => "31/1/2011")
end

When /^I update the dossier with new data$/ do
  visit edit_centre_dossier_path(@centre, @dossier)
  fill_in I18n.t("activerecord.attributes.dossier.name"), :with => "Dupont"
  fill_in I18n.t("activerecord.attributes.dossier.date_appel"), :with => "01/01/2001"
  click_button I18n.t('helpers.submit.update', :model => Dossier)
end

Then /^I should see the updated dossier$/ do
  page.should have_content "Dossier mis(e) à jour avec succès."
  page.should have_content "Dossier #LY-2001-1"
  page.should have_content "Dupont"
  page.should have_content "01/01/2001"
end

When /^I press the destroy button$/ do
  visit centre_dossier_path(@centre, @dossier)
  page.click_link I18n.t('actions.destroy')
  dialog = page.driver.browser.switch_to.alert
  dialog.text.should == I18n.t('actions.confirm')
  dialog.accept
end

Then /^the dossier should be destroyed$/ do
  page.should have_content "Dossier détruit(e) avec succès."
end
