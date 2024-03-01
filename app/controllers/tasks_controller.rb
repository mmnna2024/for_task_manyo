class TasksController < ApplicationController
  before_action :set_task, :correct_user, only: %i[ show edit update destroy ]
  skip_before_action :logout_required

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all

    if params[:search].present?
      @tasks = Task.seach_by_params(params)
    end

    if params[:sort_deadline_on].present? || params[:sort_priority].present?
      @tasks = Task.sort_by_columns(params)
    end

    @tasks = @tasks.sort_by_created_at.page(params[:page]).per(10)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
      if @task.save
        redirect_to tasks_path, flash: { notice: t('.created') }
      else
        render :new
      end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, flash: { notice: t('.updated') } }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, flash: { notice: t('.destroyed') } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      unless @task
        redirect_to tasks_path, flash: { notice: "アクセス権限がありません" }
      end
    end

end
