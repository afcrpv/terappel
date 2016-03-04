require 'rails_helper'

feature 'Dossiers saisie' do
  given(:user)           { create(:member) }
  given(:centre)         { user.centre }
  given!(:dossier)       { create(:dossier, code: 'LY2013001', centre: centre) }
  given(:other_centre)   { create(:centre, name: 'Bordeaux') }
  given!(:other_dossier) { create(:dossier, code: 'BX1200001', centre: other_centre) }
  given!(:specialite)    { create(:specialite, name: 'spec1') }
  given!(:produit)       { create(:produit, name: 'produit1') }
  given!(:corr)          { create(:correspondant, centre: centre) }
  given!(:other_corr)    { create(:correspondant, centre: other_centre) }

  background { login user }

  context 'dossier global search' do
    background { click_on 'Saisie/Correction' }
    scenario 'allows creating dossiers when submitted code does not exist', :js do
      fill_in 'codedossier', with: 'LY1111001'
      click_button 'OK'
      expect(page).to have_content("Le dossier LY1111001 n'existe pas")
      click_on("Clickez ici pour le créer")
      expect(page.find('#dossier_code').value).to eq('LY1111001')
    end

    scenario 'opens dossier when code exists', :js do
      fill_in 'codedossier', with: 'LY2013001'
      choose_autocomplete_result 'LY2013001', '#codedossier'
      expect(find_field('codedossier').value).to include('LY2013001')
      click_button 'OK'
      expect(page).to have_content 'Modification Dossier LY2013001'
    end
  end

  scenario 'creation', :js do
    visit new_dossier_path
    fill_in 'dossier_name', with: 'Martin'
    fill_in 'dossier_code', with: 'LY2013003'
    fill_in 'dossier_date_appel', with: '11/01/2012'
    select 'Oui', from: 'dossier_expo_terato'
    select 'Oui', from: 'dossier_a_relancer'
    click_on 'Oui'
    click_on 'EXPOSITION'
    within '.tab-pane#expositions' do
      click_on 'Ajouter une exposition'
      expect(find('.nested-fields')).to be_visible
      select2 produit.name, from: 'Exposition', search: true
      find_link('Valider').trigger('click')
    end
    find_button('Enregistrer et continuer').trigger('click')
    expect(page).to have_content "Dossier LY2013003, création effectuée avec succès."
    expect(page).to have_css('form.simple_form')
    click_button 'Enregistrer et fermer'
    expect(Dossier.last.centre).to eq(centre)
    expect(page.current_path).to eq(dossiers_path)
    expect(page).to have_content "Dossier LY2013003, modification effectuée avec succès."
    expect(page).not_to have_content('BX1200001')
  end

  scenario 'forbid editing other centres dossiers' do
    visit edit_dossier_path(other_dossier)
    expect(page).to have_content "Vous ne pouvez pas modifier un dossier n'appartenant pas à votre CRPV !"
    expect(current_path).to eq(dossiers_path)
  end

  scenario 'update' do
    visit edit_dossier_path(dossier)
    fill_in 'dossier_name', with: ''
    click_button 'Enregistrer et continuer'
    expect(page).to have_content 'erreurs'
    fill_in 'dossier_name', with: 'Martin'
    click_button 'Enregistrer et fermer'
    expect(page).to have_content "Dossier LY2013001, modification effectuée avec succès."
  end

  context 'correspondants', :js, :focus do
    scenario 'demandeur can be created/updated from dossier form' do
      visit new_dossier_path
      within '#dossier_demandeur_id_field' do
        click_on 'Ajout'
      end
      expect(find('#mainModal')).to have_content('Nouveau Correspondant')
      fill_in 'correspondant_nom', with: 'test test'
      select 'spec1', from: 'Spécialité'
      fill_in 'Ville', with: 'Lyon'
      fill_in 'Code Postal', with: '69005'
      click_on 'Créer un(e) Correspondant'
      expect(find('#dossier_demandeur_id_field')).to have_content('test test - spec1 - 69005 - Lyon')
      find('#dossier_demandeur_id_field').find_link('Voir/modifier').click
      within '#mainModal' do
        expect(page).to have_content('test test - spec1 - 69005 - Lyon')
      end
      fill_in 'correspondant_nom', with: 'test1 test'
      click_on 'Modifier ce(tte) Correspondant'
      expect(find('#dossier_demandeur_id_field')).to have_content 'test1 test - spec1 - 69005 - Lyon'
    end

    context 'for relance' do
      background do
        visit new_dossier_path
        within '#dossier_demandeur_id_field' do
          click_on 'Ajout'
        end
        sleep 2
        fill_in 'correspondant_nom', with: 'test test'
        select 'spec1', from: "Spécialité"
        fill_in 'Ville', with: 'Lyon'
        fill_in 'Code Postal', with: '69005'
        click_on 'Créer un(e) Correspondant'
        sleep 2
        select 'Oui', from: 'Relance'
        sleep 1
      end

      context 'when relance is the same as demandeur' do
        background do
          within '#relance' do
            click_button 'Oui'
          end
        end

        scenario 'copied demandeur is shown in relance field' do
          expect(find('#dossier_relance_id_field')).to be_visible
          within '#dossier_relance_id_field' do
            expect(page).to have_content 'test test - spec1 - 69005 - Lyon'
          end
        end

        scenario 'editing demandeur updates relance' do
          find('#dossier_demandeur_id_field').find_link('Voir/modifier').click
          fill_in 'correspondant_nom', with: 'foobar'
          click_on 'Modifier ce(tte) Correspondant'
          expect(find('#dossier_demandeur_id_field')).to have_content 'foobar - spec1 - 69005 - Lyon'
          expect(find('#dossier_relance_id_field')).to have_content 'foobar - spec1 - 69005 - Lyon'
        end
      end

      context 'when relance is not the same as demandeur' do
        background do
          within '#relance' do
            click_button 'Non'
          end
          within '#dossier_relance_id_field' do
            click_on 'Ajout'
          end
          expect(find('#mainModal')).to have_content('Nouveau Correspondant')
          fill_in 'correspondant_nom', with: 'test testone'
          select 'spec1', from: 'Spécialité'
          fill_in 'Ville', with: 'Lyon'
          fill_in 'Code Postal', with: '69005'
          click_on 'Créer un(e) Correspondant'
        end

        scenario 'can create new corr à relancer' do
          expect(find('#dossier_relance_id_field')).to have_content('test testone - spec1 - 69005 - Lyon')
          expect(find('#dossier_demandeur_id_field')).not_to have_content('test testone - spec1 - 69005 - Lyon')
        end

        scenario 'editing relance updates relance only' do
          find('#dossier_relance_id_field').find_link('Voir/modifier').click
          expect(find('#mainModal')).to have_content('test testone - spec1 - 69005 - Lyon')
          fill_in 'correspondant_nom', with: 'test1 testone'
          click_on 'Modifier ce(tte) Correspondant'
          sleep 2
          expect(find('#dossier_relance_id_field')).to have_content('test1 testone - spec1 - 69005 - Lyon')
          expect(find('#dossier_demandeur_id_field')).not_to have_content('test1 testone - spec1 - 69005 - Lyon')
        end
      end
    end
  end
end
