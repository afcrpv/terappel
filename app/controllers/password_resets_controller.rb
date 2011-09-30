class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  skip_authorization_check

  def create
    user = User.find_by_email(params[:email])
    user.deliver_reset_password_instructions! if user
    redirect_to login_path, :notice => t('sessions.password_resets.instructions_sent')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated unless @user
  end

  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated unless @user
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to login_path, :notice => t('sessions.password_resets.password_updated')
    else
      render :edit
    end
  end
end
