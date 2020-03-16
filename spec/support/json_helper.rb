module JsonHelper
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  RSpec.configure do |config|
    config.include JsonHelper
  end
end