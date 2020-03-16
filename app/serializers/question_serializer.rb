class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :label, :test_id, :description, :options
  def options
    ActiveModel::SerializableResource.new(object.options,  each_serializer: OptionSerializer)
  end
end
