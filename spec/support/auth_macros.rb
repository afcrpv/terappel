module AuthMacros
  def login(user = nil)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Mot de passe", with: user.password
    click_on "Connexion"
  end
end
