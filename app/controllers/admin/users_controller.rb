class Admin::UsersController < ApplicationController
  #before_action :admin_user
  skip_before_action :login_required, :logout_required

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, flash: { notice: t('.created') }
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
        redirect_to admin_users_path, flash: { notice: t('.updated') }
    else
        render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.tasks.destroy_all
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  # def admin_user
  #   redirect_to root_path unless current_user.admin?
  # end
end
