class Api::V1::TestsController < Api::ApplicationController

  api :GET, '/v1/tests', "Get list of Tests"
  formats ['json']
  description 'This endpoint returns list of Tests include Questions list of each test. Need to pass auth_token to get the result.'
  error code: 401, desc: "Unauthorized"
  param :auth_token, String, required: true, desc: 'Authentication token'
  param :page, Integer, required: false, desc: 'Current page number. this endpoint returns the records of page 1 as default if this field is blank.'
  param :per_page, Integer, required: false, desc: 'Number of records per page. This endpoint returns 10 records as default.'
  example 'curl -i -H "Accept: application/json" -Hype: application/json" -X GET http://localhost:3000/api/v1/tests?auth_token=zKJN5nx9XWMyAVUzgCH8'

  example'
  Error:
  {
      "status": 401,
      "message": "Unauthorized",
      "errors": [
                  {
                    "field": "auth",
                    "message": "Missing or Invalid token"
                  }
                ]
    }

    Success:
    [
        {
            "id": 19,
            "name": "TEST 1",
            "description": "TEST 1",
            "questions": [
                {
                    "id": 17,
                    "label": "Question 1 of TEST 1",
                    "description": "Question 1 of TEST 1",
                    "options": [
                        {
                            "id": 1,
                            "answer": "answer 1",
                            "question_id": 1,
                            "correct": true
                        },
                        {
                            "id": 2,
                            "answer": "answer 2",
                            "question_id": 1,
                            "correct": false
                        }
                    ]
                },
                ...
            ]
        },
       ...
      ]'
  def index
    tests = Test.joins(questions: :options).includes(questions: :options).page(page).per(per_page).uniq
    render json: tests, status: :ok
  end

  api :GET, '/v1/tests/:id', "Get Test detail"
  description 'This endpoint returns the detail of the test includes Questions and Options'
  formats ['json']
  error code: 401, desc: "Unauthorized"
  param :auth_token, String, required: true, desc: 'Authentication token'
  param :id, :number, required: true, desc: 'ID of the test'
  example '

  curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:3000/api/v1/tests/1?auth_token=zKJN5nx9XWMyAVUzgCH8

  Error:
  {
    "status": 401,
    "message": "Unauthorized",
    "errors": [
                {
                  "field": "auth",
                  "message": "Missing or Invalid token"
                }
              ]
  }

  Success:
  {
    "id": 1,
    "name": "TESt name",
    "description": "Test Description ",
    "questions": [
        {
            "id": 1,
            "label": "Question label",
            "test_id": 1,
            "description": "question description",
            "options": [
                {
                    "id": 1,
                    "answer": "answer 1",
                    "question_id": 1,
                    "correct": true
                },
                {
                    "id": 2,
                    "answer": "answer 2",
                    "question_id": 1,
                    "correct": false
                }
            ]
        }
    ]
  }'
  def show
    test = Test.find_by id: params[:id]
    render json: test
  end

  api :POST, '/v1/tests/:id/submit_answer', "Submit answer"
  formats ['json']
  param :auth_token, String, "Authentication Token", required: true
  param :test_id, Integer, "ID of the Test", required: true
  param :question_id, Integer, "ID of the Questions", required: true
  param :option_ids, Array, of: Integer, required: true, :desc => "Array of Option ID that User think those are correct answer"
  error code: 401, desc: "Unauthorized"
  example '
    {
      "status": 200,
      "message": "OK",
      "errors": []
    }
  '
  def submit_answer
    command = SubmitAnswer.call(user_id: current_user.id,
                                test_id: params[:id],
                                question_id: params[:question_id],
                                option_ids: params[:option_ids]
                                )
    if command.success?
      message = { data: ['Saved successfully']}
      render ResponseConcern.make_render_options(200)
    end
  end

end