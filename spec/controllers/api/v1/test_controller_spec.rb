require 'spec_helper'
require 'rails_helper'

describe Api::V1::TestsController do

  let(:user) { create :student }

  let(:test) { build :test, name: 'this is a name of test', description: 'this is a description' }
  let!(:question) { test.questions.build(label: 'This is a question label', description: 'this is a description') }
  let!(:option) { question.options.build(answer: 'this is answer of the question', correct: true) }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    user.generate_token!
    test.save
    sign_in user
  end



  describe 'index' do
    subject(:do_request) { get :index, params: { auth_token: token, format: :json } }

    context 'with valid token' do
      let(:token) { user.reload.authentication_token }

      it 'returns list of tests that include questions' do
        do_request
        expect(json_response.size).to eq Test.all.size
        expect(json_response.first['id']).to eq test.id
        expect(json_response.first['questions'].size).to eq test.questions.size
      end
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }

      it 'returns error' do
        do_request
        expect(response.status).to eq 401
        expect(response.message).to eq "Unauthorized"
      end
    end
  end

  describe 'show' do
    subject(:do_request) { get :show, params: { id: test.id, auth_token: token, format: :json } }

    context 'with valid token' do
      let(:token) { user.reload.authentication_token }

      it 'returns test detail' do
        do_request
        expect(json_response['id']).to eq test.id
        expect(json_response['questions'].size).to eq test.questions.size
      end
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }

      it 'returns error' do
        do_request
        expect(response.status).to eq 401
        expect(response.message).to eq "Unauthorized"
      end
    end
  end


  describe 'submit_answer' do
    subject(:do_request) { post :submit_answer, params: { id: test.id,
                                                          test_id: test.id,
                                                          question_id: question.id,
                                                          option_ids: [option.id],
                                                          auth_token: token, format: :json } }

    context 'with valid token' do
      let(:token) { user.reload.authentication_token }

      it 'returns OK message and status code is 200' do
        do_request
        expect(response.status).to eq 200
        expect(response.message).to eq "OK"
      end
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }

      it 'returns error' do
        do_request
        expect(response.status).to eq 401
        expect(response.message).to eq "Unauthorized"
      end
    end
  end

end