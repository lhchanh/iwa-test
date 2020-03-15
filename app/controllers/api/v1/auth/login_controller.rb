class Api::V1::Auth::LoginController < Devise::SessionsController
  skip_forgery_protection
  skip_before_action :verify_signed_out_user
  include Api::V1::Concerns::Users

  def_param_group :user do
    param :user, Hash, :required => true, :action_aware => true do
      param :email, String, "Email for login", required: true
      param :password, String, "Password for login", required: true
    end
  end

  api :POST, '/v1/auth/login', "Login user"
  formats ['json']
  param_group :user, required: true
  def create
    command = AuthenticateUser.call(user_params[:email], user_params[:password])
    if command.success?
      sign_in command.result, store: false
      response_success(command.result)
    else
      login_invalid
    end
  end


  api :POST, '/v1/auth/logut', "Logout user"
  formats ['json']
  def destroy
    user = User.find_by authentication_token: params[:auth_token]
    if user
      user.update(authentication_token: nil)
      sign_out user
      response_success
    else
      response_error
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :authentication_token
  end

end