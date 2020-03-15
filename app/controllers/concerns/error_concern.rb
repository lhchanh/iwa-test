module ErrorConcern
  class << self
    def make_response_errors(message_hash)
      message_hash.map do |field, messages|
        messages.map do |message|
          Virtual::ResponseError.new(field, message)
        end
      end.flatten
    end
  end
end
