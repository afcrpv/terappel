include Warden::Test::Helpers
module AuthMacros
  def login(user = nil)
    visit login_path
    fill_in "Nom d'utilisateur", with: user.username
    fill_in "Mot de passe", with: user.password
    click_on "Connexion"
  end
end
