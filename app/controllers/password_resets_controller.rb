class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  def create
    user = User.find_by_email(params[:email])
    user.deliver_reset_password_instructions! if user
    redirect_to login_path, :notice => t('sessions.password_resets.instructions_sent')
  end
end
