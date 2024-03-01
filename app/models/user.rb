class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  before_validation { email.downcase! if email}
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  before_destroy :cannot_destroy_last_one_admin
  before_update :cannot_uncheck_last_one_admin

  private
  def cannot_destroy_last_one_admin
    if User.where(admin: true).count == 1 && self.admin?
      throw :abort
    end
  end

  def cannot_uncheck_last_one_admin
    if User.where(admin: true).count == 1 && self.admin_was == true && self.admin == false
      errors.add(:admin, :admin_cannot_uncheck)
      throw(:abort)
    end
  end
end
