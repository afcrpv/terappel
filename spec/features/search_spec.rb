require 'rails_helper'

feature 'Dossiers search' do
  given(:user) { create(:member) }
  given!(:dossier) { create(:dossier_a_relancer, code: 'LY2013001', centre: user.centre) }
  given!(:dossier2) { create(:dossier_a_relancer, code: 'LY2013002', centre: user.centre) }

  background { login user; visit search_dossiers_path }

  xscenario 'simple condition', :js do
    click_on "Ajouter Critère"
    select 'Nom produit', from: 'Champ'
    fill_in 'Valeur', with: 'produit1'
    click_on 'Rechercher'
    expect(page).to have_content('LY2013001')
  end

  xdescribe 'by produit' do
    scenario 'allows filling in multiple names', js: true do
      pending
      visit new_search_path
      produit_ids = [dossier.produits.first.id, dossier2.produits.first.id].join(',')
      find('#search_produit_tokens').set(produit_ids)
      find_button('Rechercher').trigger('click')
      page.should have_content Produit.find(produit_ids.split(',')).ored_list(:name)
      page.should have_content('LY2013001')
      page.should have_content('LY2013002')
    end
  end
end
