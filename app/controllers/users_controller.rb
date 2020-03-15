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
    if @user.update_without_password(user_params)
      flash[:notice] = I18n.t('success.messages.updated_user')
      redirect_to users_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = I18n.t('success.messages.created_user')
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
end