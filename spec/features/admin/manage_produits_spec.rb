require "spec_helper"

feature "Admin manage produits" do
  given!(:produit) {create(:produit)}
  given(:admin) {create(:admin)}

  background {login admin}

  scenario "creation" do
    visit new_admin_produit_path
    click_on "Enregistrer"
    page.should have_content(/erreur/)
    fill_in "produit_name", with: "fooman"
    click_on "Enregistrer"
    page.should have_content "succès"
    page.should have_content "Liste produits"
  end

  scenario "update" do
    visit edit_admin_produit_path(produit)
    fill_in "produit_name", with: ""
    click_on "Enregistrer"
    page.should have_content(/erreur/)
    fill_in "produit_name", with: "bal"
    click_on "Enregistrer"
    page.should have_content(/succès/)
    page.should have_content "Liste produits"
  end
end
