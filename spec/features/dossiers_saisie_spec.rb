require "spec_helper"

feature "Dossiers saisie" do
  given(:user)          {create(:member)}

  background do
    login user
    create(:dossier, code: "LY1111002", centre: user.centre)
  end

  context "dossier global search" do
    scenario "allows creating dossiers when submitted code does not exist", js: true do
      fill_in "codedossier", with: "LY1111001"
      page.execute_script("$('.topbar-search').submit()")
      page.should have_content("Le dossier LY1111001 n'existe pas")
      click_link("Clickez ici pour le créer")
      page.find('#dossier_code').value.should == "LY1111001"
    end
    scenario "opens dossier when code exists", js: true do
      fill_in "codedossier", with: "LY1111002"
      choose_autocomplete_result "LY1111002", "#codedossier"
      find_field("codedossier").value.should include("LY1111002")
      page.execute_script("$('.topbar-search').submit()")
      page.should have_content "Détails du dossier LY1111002"
    end
  end
  context "correspondants" do
    scenario "list for select2 is scoped by current user centre", focus: true do
      corr = create(:correspondant, centre: user.centre)
      other_corr = create(:correspondant, centre: create(:centre))
      visit correspondants_url(format: :json)
      page.should have_content corr.fullname
      page.should_not have_content other_corr.fullname
    end
  end
end
