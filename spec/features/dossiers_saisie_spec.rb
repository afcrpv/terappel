require "spec_helper"

feature "Dossiers saisie" do
  given(:user)           {create(:member)}
  given(:centre)         {user.centre}
  given!(:dossier)       {create(:dossier, code: "LY2013001", centre: centre)}
  given(:other_centre)   {create(:centre, name: "Bordeaux")}
  given!(:other_dossier) {create(:dossier, code: "BX1200001", centre: other_centre)}
  given!(:specialite)    {create(:specialite, name: "spec1")}
  given!(:produit)       {create(:produit, name: "produit1")}
  given!(:corr)          {create(:correspondant, centre: centre)}
  given!(:other_corr)    {create(:correspondant, centre: other_centre)}

  background {login user}

  context "dossier global search" do
    scenario "allows creating dossiers when submitted code does not exist", js: true do
      fill_in "codedossier", with: "LY1111001"
      click_button "Recherche"
      page.should have_content("Le dossier LY1111001 n'existe pas")
      click_link("Clickez ici pour le créer")
      page.find('#dossier_code').value.should == "LY1111001"
    end

    scenario "opens dossier when code exists", js: true do
      fill_in "codedossier", with: "LY2013001"
      choose_autocomplete_result "LY2013001", "#codedossier"
      find_field("codedossier").value.should include("LY2013001")
      click_button "Recherche"
      page.should have_content "Modification Dossier LY2013001"
    end
  end

  scenario "navigating form errors", js: true do
    pending "not implemented"
    visit new_dossier_path
    page.should_not have_css(".dossier-errors")
    click_button "Enregistrer et fermer"
    within ".dossier-errors" do
      click_link "Exposition"
    end
    find(".tab-pane#expositions").visible?.should be_true
    within ".dossier-errors" do
      click_link "Nom patiente"
    end
    find(".tab-pane#infos").visible?.should be_true
    page.evaluate_script('document.activeElement.id').should == "dossier_name"
  end

  scenario "creation", js: true do
    visit new_dossier_path
    find_button("Enregistrer et continuer").trigger("click")
    page.should have_css ".dossier-errors"
    click_link "EXPOSITION"
    within ".tab-pane#expositions" do
      click_link "Ajouter une exposition"
      find(".nested-fields").visible?.should be_true
      select2 produit.name, from: "Produit", search: true
      find_link("Valider").trigger("click")
    end
    within ".dossier-errors" do
      find_link("Nom patiente").trigger("click")
    end
    fill_in "dossier_name", with: "Martin"
    fill_in "dossier_code", with: "LY2013003"
    fill_in "dossier_date_appel", with: "11/01/2012"
    select "Oui", from: "dossier_expo_terato"
    select "Oui", from: "dossier_a_relancer"
    find_button("Enregistrer et continuer").trigger("click")
    page.should have_content "Dossier LY2013003, création effectuée avec succès."
    page.should have_css("form.simple_form")
    click_button "Enregistrer et fermer"
    Dossier.last.centre.should == centre
    current_path.should eq(dossiers_path)
    page.should have_content "Dossier LY2013003, modification effectuée avec succès."
    page.should_not have_content("BX1200001")
  end

  scenario "forbid editing other centres dossiers" do
    visit edit_dossier_path(other_dossier)
    page.should have_content "Vous ne pouvez pas modifier un dossier n'appartenant pas à votre CRPV !"
    current_path.should eq(dossiers_path)
  end

  scenario "update" do
    visit edit_dossier_path(dossier)
    fill_in "dossier_name", with: ""
    click_button "Enregistrer et continuer"
    page.should have_content "erreurs"
    fill_in "dossier_name", with: "Martin"
    click_button "Enregistrer et fermer"
    page.should have_content "Dossier LY2013001, modification effectuée avec succès."
  end

  context "correspondants" do
    scenario "list for select2 is scoped by current user centre" do
      visit correspondants_url(format: :json)
      page.should have_content corr.fullname
      page.should_not have_content other_corr.fullname
    end

    scenario "demandeur can be created/updated from dossier form", js: true do
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

      scenario "can copy assigned correspondant to corr à relancer", js: true do
        within "#relance" do
          click_button "Oui"
        end
        find("#dossier_relance_id_field").visible?.should be_true
        within "#dossier_relance_id_field" do
          page.should have_content "test test - spec1 - 69005 - Lyon"
        end
      end

      scenario "can create new corr à relancer", js: true do
        within "#relance" do
          click_button "Non"
          sleep 4
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
