class Option < ApplicationRecord
  belongs_to :question

  validates :answer, presence: true

  scope :correct, -> { where(correct: :true) }
end