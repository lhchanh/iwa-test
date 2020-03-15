module Api::V1::Concerns::Users extend ActiveSupport::Concern
  def load_user_authentication
    @user = User.find_by email: user_params[:email]
    return login_invalid unless @user
  end

  def ensure_params_exist
    return unless params[:user].blank?
    response_error(message: "Missing params")
  end

  def login_invalid
    response_error(message: "Invalid login", code: 400)
  end

  def response_success(data = '', message: '', code: 200, serializer: nil, data_options: nil)
    render json: {data: data, status: true, message: message, options: data_options}, status: code, serializer: serializer
  end

  def response_error(data = '', message: '', code: 422)
    render json: {data: data, status: false, message: message}, status: code
  end

end
