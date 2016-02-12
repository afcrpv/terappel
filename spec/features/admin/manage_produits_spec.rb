require 'rails_helper'

feature 'Admin manage produits' do
  given!(:produit) { create(:produit, name: 'Tartampionate') }
  given(:admin) { create(:admin) }

  background { login admin }

  scenario 'dashboard' do
    visit admin_produits_path
    expect(page).to have_content 'Administration Produits'
  end

  scenario 'creation' do
    visit new_admin_produit_path
    click_on 'Enregistrer'
    expect(page).to have_content(/erreur/)
    fill_in 'produit_name', with: 'fooman'
    click_on 'Enregistrer'
    expect(page).to have_content "succès"
  end

  scenario 'update' do
    visit edit_admin_produit_path(produit)
    fill_in 'produit_name', with: ''
    click_on 'Enregistrer'
    expect(page).to have_content(/erreur/)
    fill_in 'produit_name', with: 'bal'
    click_on 'Enregistrer'
    expect(page).to have_content(/succès/)
  end
end
