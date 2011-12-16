#encoding: utf-8

When /^I add a new bebe for a dossier$/ do
  visit new_dossier_path
  click_on "Nouveau-né"
  click_on "Ajouter Nouveau-né"
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
