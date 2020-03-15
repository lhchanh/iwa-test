class Question < ApplicationRecord
  belongs_to :test
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: :all_blank

  validates :label, :description, presence: true
  validates :options, presence: true

  validate :check_for_correct_answer

  def check_for_correct_answer
    unless options.collect {|f| f.correct?}.any?
      errors.add(:options, I18n.t('errors.messages.at_least_one_correct'))
      return false
    end
  end
end