require 'rails_helper'

RSpec.describe Api::V1::ExpaPersonController, type: :controller do
  describe '#validate_email' do
    describe 'response' do
      subject(:do_validate_email) { get :validate_email, params: { email: 'test@example.com' } }
      let(:response) { JSON.parse(subject.body) }
      
      it 'returns true if given email already exists' do
        expa_person = ExpaPerson.new(xp_email: 'test@example.com')
        expa_person.save(validate: false)
        
        expect(response["email_exists"]).to eq true
      end

      it 'returns false if given email doesn\'t exists' do
        expect(response["email_exists"]).to eq false
      end
    end
  end

end
