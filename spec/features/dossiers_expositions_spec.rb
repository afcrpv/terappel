require 'rails_helper'

feature 'Dossiers expositions management' do
  given(:user)           { create(:member) }
  given(:centre)         { user.centre }
  given!(:dossier)       { create(:dossier, code: 'LY2013001', centre: centre, produits_count: 2) }
  given!(:produit)       { create(:produit, name: 'produit1') }
  given!(:indication)    { create(:indication, name: 'indication1') }

  background do
    Capybara.current_driver = :poltergeist
    login user
  end

  describe 'for new dossiers' do
    background do
      visit new_dossier_path
      click_link 'EXPOSITION'
      within '.tab-pane#expositions' do
        click_link 'Ajouter une exposition'
        find('.nested-fields').visible?.should be_true
        select2 produit.name, from: 'Exposition', search: true
        select2 indication.name, from: 'Indication', search: true
        fill_in 'Posologie', with: '2 g/j'
        click_link 'Valider Exposition'
      end
    end

    scenario 'add a new exposition', js: true do
      page.should have_content(produit.name)
      page.should have_content(indication.name)
      page.should have_content('2 g/j')
    end

    scenario 'update existing exposition', js: true do
      find_link('Modifier exposition').trigger('click')
      fill_in 'Posologie', with: '50 mg/j'
      click_on 'Valider'
      page.should have_content('50 mg/j')
    end

    scenario 'update existing exposition after adding a new row', js: true do
      produit2 = create(:produit, name: 'produit2')
      within '.tab-pane#expositions' do
        click_link 'Ajouter une exposition'
        find('.nested-fields').visible?.should be_true
        select2 produit2.name, from: 'Exposition', search: true
        select2 indication.name, from: 'Indication', search: true
        fill_in 'Posologie', with: "100 µg/j"
        click_link 'Valider Exposition'
      end
      within(:css, 'table#expositions_summary tr:first-child td:first-child') do
        find_link('Modifier exposition').trigger('click')
      end
      fill_in 'Posologie', with: '50 mg/j'
      click_on 'Valider'
      page.should have_content('50 mg/j')
    end

    scenario 'destroy expo', js: true do
      find_link("Détruire exposition").trigger('click')
      find_link('Confirmer').trigger('click')
      page.should_not have_css('#expositions_summary tbody tr')
    end
  end

  describe 'for existing dossiers' do
    scenario 'prefill exposition summary table', js: true do
      visit edit_dossier_path(dossier)
      click_on 'EXPOSITION'
      find(:css, '#expositions_summary tbody tr:first-child').should have_content('Produit')
      find(:css, '#expositions_summary tbody tr:nth-child(2)').should have_content('Produit')
      page.should_not have_css('.nested-fields')
    end
  end
end
