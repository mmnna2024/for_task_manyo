class LabelsController < ApplicationController
  before_action :set_label, only: %i[ show edit update destroy ]
  skip_before_action :login_required, :logout_required, only: [:new, :create]

  # GET /labels or /labels.json
  def index
    @labels = Label.all
  end

  # GET /labels/1 or /labels/1.json
  def show
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels or /labels.json
  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, flash: { notice: t(".created") }
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /labels/1 or /labels/1.json
  def update
    if @label.update(label_params)
      redirect_to labels_path, flash: { notice: t(".updated") }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /labels/1 or /labels/1.json
  def destroy
    @label.destroy
    redirect_to labels_url, flash: { notice: t(".destroyed") }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_label
    @label = Label.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def label_params
    params.require(:label).permit(:name)
  end
end
