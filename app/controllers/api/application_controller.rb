module Api
  class ApplicationController < ActionController::API
    include Api::V1::Concerns::Users

    PER_PAGE_DEFAULT = 10

    before_action :ensure_params_token
    before_action :load_user_by_token
    before_action :authenticate_user_from_token!
    before_action :authenticate_user!

    private

    def ensure_params_token
      return response_error(message: "Invalid token") if params[:auth_token].blank?
    end

    def authenticate_user_from_token!
      if @current_user
        sign_in @current_user, store: false, bypass: true
      else
        return response_error(message: "Invalid token")
      end
    end

    def load_user_by_token
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