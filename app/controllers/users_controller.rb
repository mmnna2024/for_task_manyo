class UsersController < ApplicationController
  before_action :correct_user, only: [:show, :edit]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path, flash: { notice: t('.created') }
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
        redirect_to user_path, flash: { notice: t('.updated') }
    else
        render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.tasks.destroy_all
    @user.destroy
    redirect_to user_path
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user, flash: { notice: "アクセス権限がありません" } unless current_user?(@user)
  end
end
