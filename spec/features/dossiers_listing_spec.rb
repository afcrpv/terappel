require "spec_helper"

feature "Dossiers listing" do
  given(:user)          {create(:member)}

  background do
    login user
    create(:dossier, code: "LY1111002", centre: user.centre)
    create(:specialite, name: "spec1")
  end

  scenario "each row has actions for print/show and edit dossier", js: true do
    visit dossiers_path
    click_link "Imprimer le dossier LY1111002"
    find("#modal_label").should have_content "Aperçu du dossier LY1111002"
    click_button "Fermer"
    click_link "Modifier le dossier LY1111002"
    page.should have_content "Modification Dossier LY1111002"
  end
end
