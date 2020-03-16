class OptionSerializer < ActiveModel::Serializer
  attributes :id, :answer, :question_id, :correct
end
