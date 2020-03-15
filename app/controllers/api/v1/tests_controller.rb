class Api::V1::TestsController < Api::ApplicationController

  api :GET, '/v1/tests', "Get list of Tests"
  formats ['json']
  param :auth_token, String, "Authentication Token", required: true
  def index
    tests = Test.joins(:questions).includes(:questions).page(page).per(per_page)
    render json: tests, status: :ok
  end

  api :GET, '/v1/tests/:id', "Get Test detail"
  formats ['json']
  param :auth_token, String, "Authentication Token", required: true
  def show
    test = Test.find_by id: params[:id]
    render json: test, status: :ok
  end

  api :POST, '/v1/tests/:id/submit_answer', "Submit answer"
  formats ['json']
  param :auth_token, String, "Authentication Token", required: true
  param :id, Integer, "ID of the Test", required: true
  param :question_id, Integer, "ID of the Questions", required: true
  param :option_ids, Array, of: Integer, required: true, :desc => "Array of Option ID"
  def submit_answer
    command = SubmitAnswer.call(user_id: current_user.id,
                                test_id: params[:id],
                                question_id: params[:question_id],
                                option_ids: params[:option_ids]
                                )
    if command.success?
      response_success(command.result, message: 'Saved successfully')
    else
      login_invalid
    end
  end

end