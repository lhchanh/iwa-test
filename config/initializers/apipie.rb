Apipie.configure do |config|
  config.app_name                = "ChanhLeIwaTest"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api_docs"
  config.translate = false
  config.validate = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/**/*.rb"
end
