require 'rails_helper'

feature 'Users authentication' do
  given(:user) { create(:member) }

  describe 'with wrong credentials' do
    background { visit login_path }

    scenario 'with unknown email sees wrong email or password error' do
      fill_in 'user_email', with: 'boo@boo.com'
      fill_in 'user_password', with: 'booboocom'
      click_on 'Se connecter'
      expect(page).to have_content(I18n.t('devise.failure.not_found_in_database'))
    end

    scenario 'with wrong password sees wrong email or password error' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'booboocom'
      click_on 'Se connecter'
      expect(page).to have_content(I18n.t('devise.failure.invalid'))
    end
  end

  describe 'with good credentials' do
    background { login user }

    scenario 'logs in successfully' do
      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end

    scenario 'can log out' do
      click_on 'Se déconnecter'
      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
    end

    scenario 'can edit his profile' do
      click_link 'Modifier compte'
      fill_in 'user_email', with: 'another@example.com'
      fill_in 'user_current_password', with: user.password
      click_button 'Mettre à jour'
      expect(page).to have_content(I18n.t('devise.registrations.updated'))
    end
  end
end
