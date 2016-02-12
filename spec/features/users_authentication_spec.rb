require 'rails_helper'

feature 'Users authentication' do
  given(:user) { create(:member) }
  background { login user }

  scenario 'user login' do
    expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
  end

  scenario 'cannot login with incorrect credentials' do
    visit logout_path
    login User.new
    expect(page).to have_content('Identifiant ou mot de passe incorrect.')
  end

  scenario 'users edit their profile' do
    click_link 'Modifier compte'
    fill_in 'user_email', with: 'another@example.com'
    fill_in 'user_current_password', with: user.password
    click_button "Mettre à jour"
    expect(page).to have_content("Vous avez mis à jour votre compte avec succès.")
  end
end
