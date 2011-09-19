class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  def new
  end

  def create
    user = login(params[:username], params[:password],
      params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => t('sessions.logged_in')
    else
      flash.now.alert = t('sessions.invalid_credentials')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
