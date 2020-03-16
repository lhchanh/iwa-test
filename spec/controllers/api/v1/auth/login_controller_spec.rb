require 'spec_helper'
require 'rails_helper'

describe Api::V1::Auth::LoginController do

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let(:teacher) { create :teacher }
  let(:student) { create :student }
  let!(:user) { student }
  let(:email) { 'invalid_email@example.com' }
  let(:password) { 'invalid_password' }

  describe 'create' do
    subject(:do_request) { post :create, params: { email: email, password: password, format: :json } }

    context 'when teacher login' do
      let!(:user) { teacher }
      let(:email) { user.email }
      let(:password) { '12345678' }
      it 'returns unauthorized message' do
        do_request
        expect(response.status).to eq 401
        expect(response.message).to eq "Unauthorized"
        expect(response.body).to include I18n.t('errors.messages.access_denied')
      end
    end

    context 'when student login' do
      context 'when params are invalid' do
        it 'returns unauthorized message' do
          do_request
          expect(response.status).to eq 401
          expect(response.message).to eq "Unauthorized"
          expect(response.body).to include I18n.t('errors.messages.authenticate_fail')
        end
      end

      context 'when params are empty' do
        let(:email) { nil }
        let(:password) { nil }
        it 'returns unauthorized message' do
          do_request
          expect(response.status).to eq 401
          expect(response.message).to eq "Unauthorized"
          expect(response.body).to include I18n.t('errors.messages.missing_login_params')
        end
      end

      context 'when params are valid' do
        let(:email) { user.email }
        let(:password) { '12345678' }
        it 'returns authentication_token and status is 200' do
          do_request
          expect(response.status).to eq 200
          expect(response.message).to eq "OK"
          expect(response.body).to include user.reload.authentication_token
        end
      end
    end
  end

  describe 'destroy' do
    before do
      user.generate_token!
      sign_in user
    end

    subject(:do_request) { delete :destroy, params: { auth_token: user.authentication_token, format: :json } }

    it 'removes authentication_token' do
      expect { do_request }.to change { user.reload.authentication_token }.to(nil)
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
    end
  end
end