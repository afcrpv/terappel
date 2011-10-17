class UsersController < AuthorizedController
  before_filter :find_centre
  before_filter :decorated_user, :only => :show
  before_filter :find_accessible_user, :only => [:create, :update]
  load_and_authorize_resource :centre
  load_and_authorize_resource :user, :through => :centre

  def index
    @users = @users.reject {|u| u == current_user }
  end

  def show
  end

  def new
    @user = @centre.users.build({:role => "centre_user"}, :as => :admin)
  end

  def create
    if @user.save
      redirect_with_flash([@centre, @user])
    else
      render :new
    end
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
      redirect_with_flash([@centre, @user])
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_with_flash([@centre, @user], centre_users_path(@centre))
    end
  end

  private

  def decorated_user
    @user = UserDecorator.find(params[:id])
  end

  def find_centre
    @centre = current_user.centre
  end

  def find_accessible_user
    if params[:user].blank?
      #for the create action we need to assign attributes after the call to accessible
      @user = @centre.dossiers.build
      check_accessible_atributes
      @user.attributes = params[:user]
    else #for the update action we just need to call accessible
      check_accessible_atributes
    end
  end

  def check_accessible_atributes
    @user.accessible = :all if current_user.admin?
  end
end
