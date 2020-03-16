class Api::V1::Auth::LoginController < Devise::SessionsController
  skip_forgery_protection
  skip_before_action :verify_signed_out_user

  before_action :ensure_login_params, only: :create
  before_action :ensure_param_token, only: :destroy
  include Api::V1::Concerns::Users

  def_param_group :user do
    param :email, String, "Email for login", required: true
    param :password, String, "Password for login", required: true
  end

  api :POST, '/v1/auth/login', "Login user"
  formats ['json']
  param_group :user, required: true
  error code: 401, desc: "Unauthorized"
  description "Use email address and password to login to server. The endpoint returns user's information and authentication token. "
  example "Success: {
            \"id\": 5,
            \"name\": \"Student 1\",
            \"email\": \"student1@example.com\",
            \"authentication_token\": \"ou2puUKmFBqHcjt16n2h\"
          }"

  example "Error: {
            \"status\": 401,
            \"message\": \"Unauthorized\",
            \"errors\": [
                        {
                          \"field\": \"auth\",
                          \"message\": \"Missing email address or password\"
                        }
                      ]
          } "
  def create
    command = AuthenticateUser.call(params[:email], params[:password])
    if command.success?
      sign_in command.result
      the_serializer = UserSerializer.new(command.result)
      render json: the_serializer.serializable_hash
    else
      auth_error = { auth: command.errors[:user_authentication] }
      render ResponseConcern.make_render_options(401, auth_error)
    end
  end


  api :DELETE, '/v1/auth/logout', "Logout user"
  formats ['json']
  error code: 401, desc: "Unauthorized"
  param :auth_token, String, required: true, desc: 'Authentication token'
  description "Use authentication_token to logout. The endpoint returns OK message and status code 200 if success. "
  example "Success: {
            \"status\": 200,
            \"message\": \"OK\",
            \"errors\": []
          }"
  example "Error: {
            \"status\": 401,
            \"message\": \"Unauthorized\",
            \"errors\": [
                        {
                          \"field\": \"auth\",
                          \"message\": \"Missing or Invalid token\"
                        }
                      ]
          } "

  def destroy
    user = User.find_by authentication_token: params[:auth_token]
    if user
      user.update(authentication_token: nil)
      sign_out user
      render ResponseConcern.make_render_options(200)
    else
      auth_error = { auth: [I18n.t('errors.messages.missing_or_invalid_token')]}
      render ResponseConcern.make_render_options(401, auth_error)
    end
  end

  private
    def ensure_login_params
      if params[:email].blank? || params[:password].blank?
        auth_error = { auth: [I18n.t('errors.messages.missing_login_params')]}
        render ResponseConcern.make_render_options(401, auth_error)
      end
    end

    def ensure_param_token
      if params[:auth_token].blank?
        auth_error = { auth: [I18n.t('errors.messages.missing_or_invalid_token')]}
        render ResponseConcern.make_render_options(401, auth_error)
      end
    end

end