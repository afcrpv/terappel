require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = Factory(:user)
    visit login_path
    click_link I18n.t('sessions.new.forgot_password')
    fill_in I18n.t('sessions.new.email'), :with => user.email
    click_button I18n.t('sessions.new.reset_password')
  end
end
