require "spec_helper"

feature "Dossiers listing" do
  given(:user)          {create(:member)}
  given!(:dossier)      {create(:dossier_a_relancer, code: "LY2013001", centre: user.centre)}

  background {login user}

  scenario "each row has actions for print/show and edit dossier", js: true do
    visit dossiers_path
    click_link "Imprimer le dossier LY2013001"
    find("#modal_label").should have_content "Fiche dossier LY2013001"
    click_button "Fermer"
    find_link("Modifier le dossier LY2013001").trigger("click")
    page.should have_content "Modification Dossier LY2013001"
  end

  scenario "export dossiers to excel" do
    visit dossiers_path(format: :xls)
    page.should have_content("LY2013001")
  end

  scenario "export dossiers to pdf" do
    visit dossiers_path(format: :pdf)
    page.response_headers["Content-Type"].should == "application/pdf"
  end

  scenario "access dossier pdf" do
    visit dossier_path(dossier, format: :pdf)
    page.response_headers["Content-Type"].should == "application/pdf"
  end

  scenario "access dossier fiche dense", js: true do
    visit dossiers_path
    click_link "Imprimer le dossier"
    within ".modal" do
      page.should have_content "Fiche dossier LY2013001"
    end
  end
end
