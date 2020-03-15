class User < ApplicationRecord
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[Teacher Student]

  validates :email, :name, :type, presence: true
  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 50 }
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: false

  def admin?
    is_a? Teacher
  end
end
