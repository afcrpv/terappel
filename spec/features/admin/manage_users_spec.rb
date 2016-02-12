# encoding: utf-8
require 'spec_helper'

feature 'Admin manage users' do
  given!(:centre) { create(:centre) }
  given(:admin) { create(:admin) }

  background { login admin }

  scenario 'creation' do
    visit new_admin_user_path
    click_on 'Enregistrer'
    page.should have_content 'erreurs'
    fill_in 'user_username', with: 'fooman'
    fill_in 'user_email', with: 'fooman@test.com'
    fill_in 'user_password', with: 'barbaz1976'
    fill_in 'user_password_confirmation', with: 'barbaz1976'
    select centre.name, from: 'Centre'
    click_on 'Enregistrer'
    page.should have_content "succès"
    page.should have_content 'Liste utilisateurs'
  end

  scenario 'modification' do
    pending 'implement me MAINTENANT!'
  end
  scenario 'approbation' do
    pending 'implement me NAU!'
  end
end
