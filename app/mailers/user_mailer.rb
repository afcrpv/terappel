class UserMailer < ActionMailer::Base
  default from: "notifications@example.com"

  def reset_password_email(user)
    @user = user
    token = user.reset_password_token
    @url  = url_for(edit_password_reset_url(token))#"http://0.0.0.0:3000/password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email,
         :subject => t('sessions.password_resets.mail_subject'))
  end
end
