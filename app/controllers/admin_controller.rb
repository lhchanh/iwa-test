class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |e|
    sign_out current_user
    redirect_to user_session_path, flash: { alert: e.message }
  end

  private
  def authorize_admin!
    raise CanCan::AccessDenied unless current_user.admin?
  end
end