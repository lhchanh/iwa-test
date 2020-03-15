class Test < ApplicationRecord
  has_many :questions, inverse_of: :test, dependent: :destroy
  has_many :options, through: :questions

  accepts_nested_attributes_for :questions, allow_destroy: true
  validates :name, :description, presence: true
  validates :questions, presence: true
end