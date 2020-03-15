class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  # before_filter do
  #   # raise CanCan::AccessDenied unless current_user.is_a? Employer
  #   redirect_to "/users/sign_in"
  # end

  before_action :load_user, only: [:show, :update, :edit]

  PAGE_DEFAULT = 1
  PER_PAGE_DEFAULT = 1

  def index
    @users = User.page(page).per(per_page)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    p "100"*100
  end

  def create
    p "444" * 100
    binding.pry
  end

  def destroy
    p "destroy"*100
  end

  private
  def load_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :phone, :email_notification_type,
      :password, :password_confirmation, :current_password
    )
  end

  def page
    params[:page] || PAGE_DEFAULT
  end

  def per_page
    params[:per_page] || PER_PAGE_DEFAULT
  end
end