module ResponseConcern
  extend ActiveSupport::Concern

  class << self
    def make_render_options(http_status_code, message_src = nil)
      errors = if message_src.blank?
                 []
               elsif message_src.is_a?(Hash)
                 ErrorConcern.make_response_errors(message_src)
               elsif message_src.is_a?(Array)
                 message_src.map do |message_hash|
                   messages                = message_hash[:messages]
                   message_hash[:messages] = ErrorConcern.make_response_errors(messages)
                   message_hash
                 end
               end

      { json: Virtual::Response.new(http_status_code, errors).as_json, status: http_status_code }
    end

    def make_permission_error
      error_message = ErrorConcern.make_response_errors(auth: [I18n.t('errors.access_denied')])

      { json: Virtual::Response.new(403, error_message).as_json, status: 403 }
    end
  end
end
