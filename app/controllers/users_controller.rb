class UsersController < AdminController
  before_action :load_user, only: [:show, :update, :edit, :destroy]

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
    success = is_change_password? ?
      @user.update_with_password(user_params) :
      @user.update_without_password(user_params)

    if success
      flash[:notice] = 'Update successfully'
      redirect_to users_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'Create successfully'
      redirect_to users_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy!
    @users = User.page(page).per(per_page)
    respond_to do |format|
     format.html { redirect_to users_url }
     format.json { head :no_content }
     format.js   { render :layout => false }
    end
  end

  private
  def load_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :type, :password, :password_confirmation, :current_password
    )
  end

  def is_change_password?
    user_params[:password].present? || user_params[:password_confirmation].present?
  end
end