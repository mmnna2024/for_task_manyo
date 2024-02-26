class Task < ApplicationRecord
  validates :title, :content, :deadline_on, :priority, :status, presence: true
  enum priority: {
    低: 0,
    中: 1,
    高: 2,
  }
  enum status: {
    未着手: 0,
    着手中: 1,
    完了: 2,
  }

  scope :title_search, ->(part) {where("title like ?", "%#{part}%")}
  scope :status_search, ->(status) {where(status: status)}
end
