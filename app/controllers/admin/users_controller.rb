class Admin::UsersController < Admin::ApplicationController
  before_action :set_categories, only: [:new, :create, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :archive]

  def index
    # List all users that are NOT archived.
    @users = User.excluding_archived.order(:email)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    build_roles_for(@user)
    if @user.save
      flash[:notice] = "User has been created."
      redirect_to admin_users_path
    else
      flash.now[:alert] = "User has not been created."
      render "new"
    end
  end

  def edit
  end

  def update
    # Submitting a blank password means do not change the password, therefore
    # just remove it from the params hash to avoid errors.
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end

    User.transaction do
      @user.roles.clear
      build_roles_for(@user)

      if @user.update(user_params)
        flash[:notice] = "User has been updated."
        redirect_to admin_users_path
      else
        flash.now[:alert] = "User has not been updated."
        render "edit"
      end
    end
  end

  def archive

    # You are NOT allowed to archive yourself.
    if @user == current_user
      flash[:alert] = "You cannot archive yourself!"
    else
      @user.archive
      flash[:notice] = "User has been archived."
    end

    redirect_to admin_users_path
  end

  private

    def user_params
      params.require(:user).permit(:fullname, :username, :email, :bio, :password, :admin, :worker, :customer)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def set_categories
      @categories = Category.order(:name)
    end

    def build_roles_for(user)
      role_data = params.fetch(:roles, [])
      role_data.each do |category_id, role_name|
        if role_name.present?
          @user.roles.build(category_id: category_id, role: role_name)
        end
      end
    end
end
