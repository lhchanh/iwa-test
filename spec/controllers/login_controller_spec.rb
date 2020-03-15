require 'spec_helper'

describe JobsController do
  let(:force_same_worker_on_mdj_same_worker) { false }
  let!(:customer) { create :customer, use_conditional_withdrawal: true, force_same_worker_on_mdj_same_worker: force_same_worker_on_mdj_same_worker }
  let(:employer) { create :employer, customer: customer }
  let(:worker) { create :worker, phone: '202-555-0191' }
  let(:job_request) { create :job_request, employer: employer }

  before do
    sign_in employer
  end

  describe 'update' do
  end
end
