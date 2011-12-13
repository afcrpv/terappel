module LoginHelpers
  def login(name, password)
    visit('/login')
    fill_in "user_username", :with => name
    fill_in "user_password", :with => password
    click_on "Connexion"
  end
end

World(LoginHelpers)
