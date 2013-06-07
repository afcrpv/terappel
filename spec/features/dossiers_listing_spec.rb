require "spec_helper"

feature "Dossiers listing" do
  given(:user)          {create(:member)}
  given(:dossier)       {create(:dossier, code: "LY1111002", centre: user.centre)}

  background do
    login user
    create(:specialite, name: "spec1")
  end

  scenario "each row has actions for print/show and edit dossier", js: true, slow: true do
    visit dossiers_path
    click_link "Imprimer le dossier LY1111002"
    find("#modal_label").should have_content "Aperçu du dossier LY1111002"
    click_button "Fermer"
    click_link "Modifier le dossier LY1111002"
    page.should have_content "Modification Dossier LY1111002"
  end

  scenario "export dossiers to excel" do
    visit dossiers_path(format: :xls)
    page.should have_content("LY1111002")
  end

  scenario "export dossiers to pdf" do
    visit dossiers_path(format: :pdf)
    page.response_headers["Content-Type"].should == "application/pdf"
  end

  scenario "access dossier pdf", focus: true do
    visit dossier_path(dossier, format: :pdf)
    page.response_headers["Content-Type"].should == "application/pdf"
  end

  scenario "access dossier fiche dense", js: true do
    dossier = create(:dossier, code_bnpv: "LY2013001", crpv: crpv1, enquete: enquete)
    visit dossiers_path
    click_link "Imprimer le dossier"
    within ".modal" do
      page.should have_content "Fiche dossier LY1111002"
    end
  end
end
