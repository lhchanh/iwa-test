module Api
  class ApplicationController < ActionController::API
    include Api::V1::Concerns::Users

    PER_PAGE_DEFAULT = 10

    before_action :ensure_params_token
    before_action :authorize_user!

    private

    def ensure_params_token
      return response_error(message: "Invalid token") if params[:auth_token].blank?
    end

    def authorize_user!
      return response_error(nil, message: 'Unauthorized user', code: :unauthorized) if current_user.blank?
    end

    def current_user
      @current_user ||= User.find_by authentication_token: params[:auth_token]
    end

    def page
      params[:page] || 1
    end

    def per_page
      params[:per_page] || PER_PAGE_DEFAULT
    end
  end
end