#encoding: utf-8
require "spec_helper"

feature "Users authentication" do
  given(:user) {create(:member)}
  background {login user}

  scenario "user login" do
    page.should have_content(I18n.t("devise.sessions.signed_in"))
  end

  scenario "cannot login with incorrect credentials" do
    click_link "Déconnexion"
    login User.new
    page.should have_content("Identifiant ou mot de passe incorrect.")
  end

  scenario "users edit their profile" do
    click_link "Modifier compte"
    fill_in "Courriel", with: "another@example.com"
    fill_in "Mot de passe actuel", with: user.password
    click_button "Mettre à jour"
    page.should have_content("Vous avez mis à jour votre compte avec succès.")
  end
end
