class TestsController < AdminController
  before_action :load_test, only: [:show, :update, :edit, :destroy]

  def index
    @tests = tests_list
  end

  def new
    @test = Test.new
  end

  def create
    @test = Test.new test_params
    if @test.save
      flash[:notice] = I18n.t('success.messages.created_test')
      redirect_to tests_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @test.update test_params
      flash[:notice] = I18n.t('success.messages.updated_test')
      redirect_to tests_path
    else
      render :edit
    end
  end

  def destroy
    @test.destroy!
    @tests = tests_list
    respond_to do |format|
     format.html { redirect_to tests_url }
     format.json { head :no_content }
     format.js   { render :layout => false }
    end
  end

  def show
  end

  private
  def tests_list
    Test.joins(:questions).includes(:questions).page(page).per(per_page)
  end

  def load_test
    @test = Test.find_by(id: params[:id])
  end

  def test_params
    params.require(:test).permit(:name,
                                 :description,
                                 questions_attributes: [:id,
                                                        :label,
                                                        :description,
                                                        :_destroy,
                                                        options_attributes: [
                                                          :id,
                                                          :answer,
                                                          :correct,
                                                          :_destroy
                                                        ]])
  end
end