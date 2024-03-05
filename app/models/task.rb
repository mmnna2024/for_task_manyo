class Task < ApplicationRecord
  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: {低: 0, 中: 1, 高: 2,}
  enum status: {未着手: 0, 着手中: 1, 完了: 2,}

  scope :title_search, ->(part) {where("title like ?", "%#{part}%")}
  scope :status_search, ->(status) {where(status: status)}
  #scope :status_search_v2, ->(status) {status ? where(status: status) : nil}

  def self.sort_by_created_at
    Task.all.order(created_at: :desc)
  end

  def self.seach_by_params(params)
    if has_status_title?(params)#パラメータにタイトルとステータスの両方があった場合
      Task.title_search(params[:search][:title]).status_search(params[:search][:status])
    elsif has_only_title?(params)#パラメータにタイトルのみがあった場合
      Task.title_search(params[:search][:title])
    elsif has_only_status?(params)#パラメータにステータスのみがあった場合
      Task.status_search(params[:search][:status])
    else
      Task.all.sort_by_created_at
    end
  end

  def self.sort_by_columns(params)
    if params[:sort_deadline_on] == 'true'
      Task.all.order(deadline_on: :asc)
    elsif params[:sort_priority] == 'true'
      Task.all.order(priority: :desc)
    else
      Task.all
    end
  end 


  private

  def self.has_status_title?(params)
    params[:search][:status].present? && params[:search][:title].present?
  end

  def self.has_only_title?(params)
    params[:search][:title].present? && params[:search][:status].blank?
  end

  def self.has_only_status?(params)
    params[:search][:status].present? && params[:search][:title].blank?
  end
end
