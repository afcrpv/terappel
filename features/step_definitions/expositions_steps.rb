#encoding: utf-8

When /^I add a new exposition for a dossier$/ do
  visit new_dossier_path
  click_on "Exposition"
  click_on "Ajouter Expo"
  select "ACICLOVIR", :from => "Exposition"
  select "T1", :from => "Terme d'exposition"
  select "HERPES", :from => "Indication"
  fill_in "Posologie", :with => "2 g/j"
  click_on "Valider"
end

Then /^the added exposition should belong to the dossier$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the added exposition should appear in the summary table$/ do
  find(:css, '#expositions_summary tbody').should have_content('ACICLOVIR')
  find(:css, '#expositions_summary tbody').should have_content('T1')
  find(:css, '#expositions_summary tbody').should have_content('HERPES')
  find(:css, '#expositions_summary tbody').should have_content('2 g/j')
end

When /^I update an existing exposition for a dossier$/ do
  step %{I add a new exposition for a dossier}
  click_on "M"
  fill_in "Posologie", :with => "50 mg/j"
  click_on "Valider"
end

Then /^the corresponding row in the summary table should be updated$/ do
  find(:css, '#expositions_summary tbody').should have_content('50 mg/j')
end

When /^I add another exposition$/ do
  click_on "Ajouter Expo"
  select "ACICLOVIR", :from => "Exposition"
  select "T1", :from => "Terme d'exposition"
  select "HERPES", :from => "Indication"
  fill_in "Posologie", :with => "3 g/j"
  click_on "Valider"
end

When /^I update the first exposition$/ do
  within(:css, "table#expositions_summary tr:first-child td") do
    click_on "M"
  end
  fill_in "Posologie", :with => "50 mg/j"
  click_on "Valider"
end

Then /^the first row should be updated$/ do
  find(:css, '#expositions_summary tbody tr:first-child').should have_content('50 mg/j')
end

When /^I destroy an existing exposition for a dossier$/ do
  step %{I add a new exposition for a dossier}
  click_on "X"
end

Then /^the corresponding row in the summary table should disappear$/ do
  find(:css, '#expositions_summary tbody tr').should_not have_content('ACICLOVIR')
end

Then /^the expo should be ready to be destroyed$/ do
  find(:css, '.nested-fields input[type=hidden]').value.should == "1"
end

Given /^an existing dossier with expositions$/ do
  step %{an existing dossier}
  @dossier.expositions_attributes = [ 
    {produit_id: Produit.first.id, expo_terme_id: ExpoTerme.first.id, indication_id: Indication.first.id, dose: "1 g/j"},
    {produit_id: Produit.first.id, expo_terme_id: ExpoTerme.first.id, indication_id: Indication.first.id, dose: "2 g/j"},
  ]
  @dossier.save!
end

When /^I edit the dossier$/ do
  visit edit_dossier_path(@dossier)
end

Then /^the expo summary table should be filled up with existing expos$/ do
  click_on "Exposition"
  find(:css, '#expositions_summary tbody tr:first-child').should have_content('1 g/j')
  find(:css, '#expositions_summary tbody tr:nth-child(2)').should have_content('2 g/j')
  find(:css, ".nested-fields").visible?.should_not be_true
end
