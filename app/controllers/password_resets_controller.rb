class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  def new
  end

  def create
    redirect_to :root
  end
end
