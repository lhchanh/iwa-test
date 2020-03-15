require 'spec_helper'
require 'rails_helper'

describe Api::V1::Auth::LoginController do

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  let!(:user) { create :student }
  let(:user_params) { { email: user.email, password: '12345678' } }

  describe 'create' do
    subject(:do_request) { post :create, params: { email: user.email, password: '12345678', format: :json } }

    it 'test' do
      do_request
    end
  end

  describe 'destroy' do

  end
end