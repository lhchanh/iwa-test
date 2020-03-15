class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :label, :description

  belongs_to :test
  has_many :options
end
