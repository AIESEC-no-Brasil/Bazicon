require 'rails_helper'

describe UpdateStatus do
  let(:payment) { create(:payment) }
  subject(:do_update_status) do
    UpdateStatus.call(payment: payment.id, status: "paid")
  end

  it do
    expect { do_update_status}.to change{Payment.find(payment.id).status}.to("paid")
  end
end
