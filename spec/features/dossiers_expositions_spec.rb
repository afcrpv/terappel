require "spec_helper"

feature "Dossiers expositions management" do
  given(:user)           {create(:member)}
  given(:centre)         {user.centre}
  given!(:dossier)       {create(:dossier, code: "LY2013001", centre: centre)}
  given!(:produit)       {create(:produit, name: "produit1")}
  given!(:indication)    {create(:indication, name: "indication1")}

  background {Capybara.current_driver = :selenium; login user}

  scenario "add a new exposition", js: true, focus: true do
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
