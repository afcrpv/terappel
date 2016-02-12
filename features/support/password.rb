module PasswordHelpers
  def request_password(user, email)
    visit new_user_password_path(user)
    fill_in 'user_email', with: email
    click_button I18n.t('devise.passwords.send_reset_password_instructions')
  end
end

World(PasswordHelpers)
