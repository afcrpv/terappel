class Notifications < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.signup.subject
  #
  def signup(user)
    @user = user

    mail to: ENV['ADMIN_EMAIL']
  end
end
