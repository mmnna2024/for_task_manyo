class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  before_action :logout_required, only: [:new, :create]

  private

  def login_required
    redirect_to new_session_path, flash: { notice: "ログインしてください" } unless current_user
  end

  def logout_required
    redirect_to tasks_path, flash: { notice: "ログアウトしてください" } if current_user
  end
end
