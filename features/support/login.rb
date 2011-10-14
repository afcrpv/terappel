module LoginHelpers
  def login(name, password)
    visit('/login')
    fill_in "user_username", :with => name
    fill_in "user_password", :with => password
    click_button "#{I18n.t('devise.shared.sign_in')}"
  end
end

World(LoginHelpers)
