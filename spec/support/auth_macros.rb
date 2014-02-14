include Warden::Test::Helpers
module AuthMacros
  def login(user = nil)
    visit login_path
    fill_in "user_username", with: user.username
    fill_in "user_password", with: user.password
    click_on "Se connecter"
  end
end
