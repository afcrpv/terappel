require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = Factory(:user)
    visit login_path
    fill_in I18n.t('sessions.password_resets.email'), :with => user.email
    click_button I18n.t('sessions.password_resets.reset_password')
    page.should have_content(I18n.t('sessions.password_resets.instructions_sent'))
    last_email.to.should include(user.email)
  end
end
