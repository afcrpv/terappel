class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:approve, :show, :edit, :update, :destroy]
  load_and_authorize_resource :user

  def index
    @users = params[:approved] ? User.where(approved: false) : User.all
  end

  def approve
    @user.approve!
    redirect_to admin_users_url, notice: "Utilisateur '#{@user.email}' approuvé avec succès."
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_with_password(user_params)
      redirect_to admin_users_url, notice: "L'utilisateur #{@user.email} a été modifié avec succès."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    if current_user.admin?
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password, :approved, :centre_id, :role)
    else
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
    end
  end
end
