require 'rails_helper'

feature 'Users authentication' do
  given(:user) { create(:member) }
  given(:admin) { create(:admin) }
  given(:admin_email) { ENV['ADMIN_EMAIL'] }

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

  describe 'registration' do
    given!(:crpv) { create(:centre) }
    background do
      visit root_path
      click_on 'Créer un compte'
      fill_in 'user_email', with: 'foobar@example.com'
      select crpv.name, from: 'user_centre_id'
      fill_in 'user_password', with: 'ThePassword123'
      fill_in 'user_password_confirmation', with: 'ThePassword123'
      click_on 'Créer le compte'
    end

    scenario 'user is notified on screen' do
      expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_not_approved'))
    end

    scenario 'admin receives an email' do
      expect(last_email.to).to include(admin_email)
      expect(last_email.body.encoded).to match(/foobar@example.com/)
    end
  end

  scenario 'user resets password' do
    visit login_path
    click_on I18n.t('devise.shared.links.forgot_password')
    fill_in 'user_email', with: user.email
    click_on I18n.t('devise.passwords.new.submit')
    expect(current_path).to eq('/users/sign_in')
    expect(last_email.to).to include(user.email)
    open_last_email_for(user.email)
    click_first_link_in_email
    fill_in 'user_password', with: 'Foobar123456'
    fill_in 'user_password_confirmation', with: 'Foobar123456'
    click_on I18n.t('devise.passwords.change_my_password')
    expect(page).to have_content(I18n.t('devise.passwords.updated'))
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
