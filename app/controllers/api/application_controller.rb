module Api
  class ApplicationController < ActionController::API
    include Api::V1::Concerns::Users
    before_action :ensure_param_token
    before_action :load_user_by_token
    before_action :authenticate_user_from_token!
    before_action :authenticate_user!

    PER_PAGE_DEFAULT = 10

    private

    def ensure_param_token
      if params[:auth_token].blank?
        auth_error = { auth: [I18n.t('errors.messages.missing_or_invalid_token')]}
        render ResponseConcern.make_render_options(401, auth_error)
      end
    end

    def authenticate_user_from_token!
      if @current_user
        bypass_sign_in(@current_user)
      else
        auth_error = { auth: [I18n.t('errors.messages.missing_or_invalid_token')]}
        render ResponseConcern.make_render_options(401, auth_error)
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