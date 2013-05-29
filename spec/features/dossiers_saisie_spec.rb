require "spec_helper"

feature "Dossiers saisie" do
  given(:user)          {create(:member)}
  given(:centre)        {user.centre}
  given(:other_centre)  {create(:centre, name: "Bordeaux")}
  given(:other_dossier) {create(:dossier, code: "BX1200001", centre: other_centre)}

  background do
    login user
    create(:specialite, name: "spec1")
  end

  context "dossier global search" do
    scenario "allows creating dossiers when submitted code does not exist", js: true, slow: true do
      fill_in "codedossier", with: "LY1111001"
      page.execute_script("$('.topbar-search').submit()")
      page.should have_content("Le dossier LY1111001 n'existe pas")
      click_link("Clickez ici pour le créer")
      page.find('#dossier_code').value.should == "LY1111001"
    end
    scenario "opens dossier when code exists", js: true, slow: true do
      fill_in "codedossier", with: "LY1111002"
      choose_autocomplete_result "LY1111002", "#codedossier"
      find_field("codedossier").value.should include("LY1111002")
      page.execute_script("$('.topbar-search').submit()")
      page.should have_content "Modification Dossier LY1111002"
    end
  end

  scenario "creation" do
    visit new_dossier_path
    click_button "Enregistrer et continuer"
    page.should have_content "erreurs"
    fill_in "dossier_code", with: "LY1"
    fill_in "dossier_date_appel", with: I18n.l(Date.today)
    select "Oui", from: "dossier_expo_terato"
    select "Oui", from: "dossier_a_relancer"
    fill_in "dossier_name", with: "Martin"
    click_button "Enregistrer et continuer"
    page.should have_content "Dossier LY1, création effectuée avec succès."
    page.should have_css("form.simple_form")
    click_button "Enregistrer et fermer"
    Dossier.last.centre.should == centre
    current_path.should eq(dossiers_path)
    page.should have_content "Dossier LY1, modification effectuée avec succès."
    page.should_not have_content("BX1200001")
  end

  scenario "forbid editing other centres dossiers", focus: true do
    visit edit_dossier_path(other_dossier)
    page.should have_content "Vous ne pouvez pas modifier un dossier n'appartenant pas à votre CRPV !"
    current_path.should eq(dossiers_path)
  end

  scenario "update" do
    dossier = create(:dossier, code: "LY1111002", centre: centre)
    visit edit_dossier_path(dossier)
    fill_in "dossier_name", with: ""
    click_button "Enregistrer et continuer"
    page.should have_content "erreurs"
    fill_in "dossier_name", with: "Martin"
    click_button "Enregistrer et fermer"
    page.should have_content "Dossier LY1111002, modification effectuée avec succès."
  end

  context "correspondants" do
    scenario "list for select2 is scoped by current user centre" do
      corr = create(:correspondant, centre: user.centre)
      other_corr = create(:correspondant, centre: create(:centre))
      visit correspondants_url(format: :json)
      page.should have_content corr.fullname
      page.should_not have_content other_corr.fullname
    end

    scenario "demandeur can be created/updated from dossier form", js: true, slow: true do
      visit new_dossier_path
      within "#dossier_demandeur_id_field" do
        click_link "Ajout"
      end
      find("#correspondant_modal").should have_content "Nouveau correspondant"
      fill_in "correspondant_nom", with: "test test"
      select "spec1", from: "Spécialité"
      fill_in "Ville", with: "Lyon"
      fill_in "Code Postal", with: "69005"
      within ".modal-footer" do
        click_link "Enregistrer"
        sleep 2
      end
      find("#dossier_demandeur_id_field").should have_content "test test - spec1 - 69005 - Lyon"
      find("#dossier_demandeur_id_field").find_link("Voir/modifier").click
      find("#correspondant_modal").should have_content "test test - spec1 - 69005 - Lyon"
      fill_in "correspondant_nom", with: "test1 test"
      within ".modal-footer" do
        click_link "Enregistrer"
      end
      sleep 3
      find("#dossier_demandeur_id_field").should have_content "test1 test - spec1 - 69005 - Lyon"
    end

    context "for corr à relancer" do
      background do
        visit new_dossier_path
        within "#dossier_demandeur_id_field" do
          click_link "Ajout"
        end
        sleep 2
        fill_in "correspondant_nom", with: "test test"
        select "spec1", from: "Spécialité"
        fill_in "Ville", with: "Lyon"
        fill_in "Code Postal", with: "69005"
        within ".modal-footer" do
          click_link "Enregistrer"
        end
        sleep 2
        select "Oui", from: "Relance"
        sleep 1
      end

      scenario "can copy assigned correspondant to corr à relancer", js: true, slow: true do
        within "#relance" do
          click_button "Oui"
        end
        find("#dossier_relance_id_field").visible?.should be_true
        within "#dossier_relance_id_field" do
          page.should have_content "test test - spec1 - 69005 - Lyon"
        end
      end

      scenario "can create new corr à relancer", js: true, slow: true do
        within "#relance" do
          click_button "Non"
        end
        within "#dossier_relance_id_field" do
          click_link "Ajout"
        end
        find("#correspondant_modal").should have_content "Nouveau correspondant"
        fill_in "correspondant_nom", with: "test testone"
        select "spec1", from: "Spécialité"
        fill_in "Ville", with: "Lyon"
        fill_in "Code Postal", with: "69005"
        within ".modal-footer" do
          click_link "Enregistrer"
          sleep 4
        end
        find("#dossier_relance_id_field").should have_content "test testone - spec1 - 69005 - Lyon"
        find("#dossier_relance_id_field").find_link("Voir/modifier").click
        find("#correspondant_modal").should have_content "test testone - spec1 - 69005 - Lyon"
        fill_in "correspondant_nom", with: "test1 testone"
        within ".modal-footer" do
          click_link "Enregistrer"
          sleep 2
        end
        find("#dossier_relance_id_field").should have_content "test1 testone - spec1 - 69005 - Lyon"
      end
    end
  end
end
