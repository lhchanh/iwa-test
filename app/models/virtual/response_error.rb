module Virtual
  class ResponseError
    include ActiveModel::Model

    attr_reader :field, :message

    def initialize(field, message)
      @field = field
      @message = message
    end
  end
end
