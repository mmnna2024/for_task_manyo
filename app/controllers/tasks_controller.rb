class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    if params[:sort_deadline_on] == 'true'
      @tasks = Task.all.order(deadline_on: :asc, created_at: :desc)
    elsif params[:sort_priority] == 'true'
      @tasks = Task.all.order(priority: :desc, created_at: :desc)
    else
      @tasks = Task.all.order(created_at: :desc)
    end

    if params[:search].present?
      if params[:search][:status].present? && params[:search][:title].present?#パラメータにタイトルとステータスの両方があった場合
      @tasks = Task.title_search(params[:search][:title]).status_search(params[:search][:status])
        elsif params[:search][:status].blank? && params[:search][:title].present?#パラメータにタイトルのみがあった場合
        @tasks = Task.title_search(params[:search][:title])
        elsif params[:search][:status].present? && params[:search][:title].blank?#パラメータにステータスのみがあった場合
        @tasks = Task.status_search(params[:search][:status])
      end
    end

    @tasks = @tasks.page(params[:page]).per(10)
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
      if @task.save
        redirect_to tasks_path , notice: t('.created')
        #format.json { render :show, status: :created, location: @task }
      else
        render :new
        #format.json { render json: @task.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t('.updated') }
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
      format.html { redirect_to tasks_url, notice: t('.destroyed') }
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

end
