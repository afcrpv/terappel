include Warden::Test::Helpers
module AuthMacros
  def login(user = nil)
    visit login_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Se connecter'
  end
end
