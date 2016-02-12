class Admin::UsersController < ApplicationController
  respond_to :html
  before_action :set_user, only: [:approve, :show, :edit, :update, :destroy]
  load_and_authorize_resource :user

  def index
    @users = params[:approved] ? User.where(approved: false) : User.all
    respond_with @users
  end

  def approve
    @user.approve!
    redirect_to admin_users_url, notice: "Utilisateur '#{@user.email}' approuvé avec succès."
  end

  def show
  end

  def new
    @user = User.new
    respond_with @user
  end

  def create
    @user = User.create(user_params)
    respond_with @user, location: admin_users_url
  end

  def edit
  end

  def update
    @user.update(user_params)
    respond_with @user, location: admin_users_url
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
    params.require(:user).permit(role_ids: [])
  end
end
