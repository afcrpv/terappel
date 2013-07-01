require "spec_helper"

feature "Dossiers expositions management" do
  given(:user)           {create(:member)}
  given(:centre)         {user.centre}
  given!(:dossier)       {create(:dossier, code: "LY2013001", centre: centre)}
  given!(:produit)       {create(:produit, name: "produit1")}
  given!(:indication)    {create(:indication, name: "indication1")}

  background {Capybara.current_driver = :poltergeist; login user}

  scenario "add a new exposition", js: true do
    visit new_dossier_path
    click_link "EXPOSITION"
    within ".tab-pane#expositions" do
      click_link "Ajouter une exposition"
      find(".nested-fields").visible?.should be_true
      select2 produit.name, from: "Produit", search: true
      select2 indication.name, from: "Indication", search: true
      fill_in "Posologie", with: "2 g/j"
      click_link "Valider Exposition"
    end
    page.should have_content(produit.name)
    page.should have_content(indication.name)
    page.should have_content('2 g/j')
  end
end
