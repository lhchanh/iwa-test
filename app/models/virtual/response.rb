module Virtual
  class Response
    include ActiveModel::Model

    attr_reader :status, :message

    def initialize(http_status_code, errors)
      @status  = http_status_code
      @message = Rack::Utils::HTTP_STATUS_CODES[http_status_code]
      @errors  = errors
    end
  end
end
