#encoding: utf-8

When /^I add a new bebe for a dossier$/ do
  step %{I initialize a bebe for a dossier}
  select "Masculin", :from => "Sexe"
  fill_in "Poids (g)", :with => "3500"
  fill_in "Taille (cm)", :with => "50"
  fill_in "PC (cm)", :with => "38"
  fill_in "Apgar 1", :with => "8"
  fill_in "Apgar 5", :with => "10"
  select "Non", :from => "Malformation"
  select "Oui", :from => "Pathologie"
  click_on "Valider"
end

When /^I initialize a bebe for a dossier$/ do
  visit new_dossier_path
  click_on "Nouveau-né"
  click_on "Ajouter Nouveau-né"
end

Then /^the added bebe should appear in the summary table$/ do
  find(:css, '#bebes_summary tbody').should have_content('M')
  find(:css, '#bebes_summary tbody').should have_content('3500')
  find(:css, '#bebes_summary tbody').should have_content('50')
  find(:css, '#bebes_summary tbody').should have_content('38')
  find(:css, '#bebes_summary tbody').should have_content('8')
  find(:css, '#bebes_summary tbody').should have_content('10')
  find(:css, '#bebes_summary tbody').should have_content('N')
  find(:css, '#bebes_summary tbody').should have_content('O')
end

When /^I update an existing bebe for a dossier$/ do
  step %{I add a new bebe for a dossier}
  click_on "M"
  fill_in "Poids (g)", :with => "3000"
  click_on "Valider"
end

Then /^the corresponding row in the bebes table should be updated$/ do
  find(:css, '#bebes_summary tbody').should have_content('3000')
end

When /^I add another bebe/ do
  click_on "Ajouter Nouveau-né"
  sleep 1
  select "Féminin", :from => "Sexe"
  click_on "Valider"
end

When /^I update the first bebe/ do
  within(:css, "table#bebes_summary tr:first-child td") do
    click_on "M"
  end
  fill_in "Poids", :with => "5000"
  click_on "Valider"
end

Then /^the first bebe should be updated$/ do
  find(:css, '#bebes_summary tbody tr:first-child').should have_content('5000')
end

When /^I destroy an existing bebe for a dossier$/ do
  step %{I add a new bebe for a dossier}
  click_on "X"
end

Then /^the corresponding bebe in the summary table should disappear$/ do
  page.should_not have_css('#bebes_summary tbody tr')
end

Then /^the bebe should be ready to be destroyed$/ do
  find(:css, '#bebes .nested-fields input[type=hidden]').value.should == "1"
end

Given /^an existing dossier with bebes/ do
  step %{an existing dossier}
  @dossier.bebes_attributes = [
    {sexe: "Masculin", poids: "3500", malformation: "Oui"},
    {sexe: "Féminin", poids: "4000", malformation: "Non"},
  ]
  @dossier.save!
end

Then /^the bebe summary table should be filled up with existing bebes/ do
  click_on "Nouveau-né"
  find(:css, '#bebes_summary tbody tr:first-child').should have_content('3500')
  find(:css, '#bebes_summary tbody tr:nth-child(2)').should have_content('4000')
  find(:css, "#bebes .nested-fields").visible?.should_not be_true
end

When /^I add (\w+) for the bebe$/ do |association|
  singular       = association.singularize
  singular_title = association.titleize.singularize
  plural_title   = association.titleize
  click_on "Nouveau-né"
  click_on "M"
  sleep 1
  select "Oui", :from => singular_title
  token_input(plural_title, :with => plural_title[0..2])
  click_on "Valider"
end

Then /^the associations should not be mixed up$/ do
  click_on "Nouveau-né"
  %w(malformation pathologie).each do |association|
    opposite = association == "malformation" ? "pathologie" : "malformation"
    link = "a[data-original-title=#{association.pluralize.titleize}]"
    page.should have_css(link)
    page.execute_script %{$("#{link}").popover('show')}
    sleep 1
    find(:css, ".popover").should have_content("#{association.titleize}1")
    find(:css, ".popover").should_not have_content("#{opposite.titleize}1")
  end
end

Then /^I should see the added (\w+)/ do |association|
  singular       = association.singularize
  singular_title = association.titleize.singularize
  plural_title   = association.titleize
  click_on "Nouveau-né"
  malf_link = "a[data-original-title=#{plural_title}]"
  page.should have_css(malf_link)
  page.execute_script %{$("#{malf_link}").popover('show')}
  sleep 1
  find(:css, ".popover").should have_content("#{singular_title}1")
end

Given /^the bebe has malformations$/ do
  bebe = @dossier.bebes.first
  bebe.malformation_ids = [1,2]
  @dossier.save!
end

When /^I add malformations using the treeview$/ do
  click_on "Nouveau-né"
  click_on "M"
  sleep 1
  select "Oui", :from => "Malformation"
  click_on "Montrer/Modifier Malformations"
  tree = ".malformations_tree"
  page.execute_script %{$("#{tree}").jstree("check_node", "li#1")}
  find(:css, ".malformations_container").should have_content("Malformation1")
  click_on "Rajouter ces malformations"
end

Then /^the added malformations should appear as tokens$/ do
  find(:css, "ul.token-input-list-facebook").should have_content("Malformation1")
end

When /^I choose "([^"]*)" from the "([^"]*)" select$/ do |option, select|
  click_on "Nouveau-né"
  click_on "M"
  sleep 1
  select option, from: select
end

Then /^the "([^"]*)" tokens should be visible$/ do |association|
  page.find(:css, ".#{association.downcase}_tokens").visible?.should be_true
end

Then /^the "([^"]*)" tokens should be hidden$/ do |association|
  page.find(:css, ".#{association.downcase}_tokens").visible?.should_not be_true
end
