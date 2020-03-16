class TestSerializer < ActiveModel::Serializer
  attributes :id, :name, :description , :questions
  def questions
    ActiveModel::SerializableResource.new(object.questions,  each_serializer: QuestionSerializer)
  end
end
