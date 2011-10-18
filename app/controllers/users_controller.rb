class UsersController < AuthorizedController
  before_filter :find_centre
  before_filter :decorated_user, :only => :show
  load_and_authorize_resource :user

  def show
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      [:password, :password_confirmation, :current_password].map do |param|
        params[:user].delete(param)
      end
    else
      @user.errors[:base] << "Le mot de passe est incorrect" unless @user.valid_password?(params[:user][:current_password])
    end

    if @user.errors[:base].empty? && @user.update_attributes(params[:user])
      redirect_with_flash(@user)
    else
      render :edit
    end
  end

  private

  def decorated_user
    @user = UserDecorator.find(params[:id])
  end

  def find_centre
    @centre = current_user.centre
  end
end
