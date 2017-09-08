require 'rails_helper'

RSpec.describe "API" do
  let(:client) { EXPA::Client.new }
  let(:token) {
    client.auth ENV["ROBOZINHO_EMAIL"], ENV["ROBOZINHO_PASSWORD"]
    client.get_updated_token
  }

  it "generates a token" do
    expect(token).to be_an_instance_of(String)
  end

  describe "application" do
    it "responds to #index and #show" do
      index_uri = URI('https://gis-api.aiesec.org/v2/applications')
      index_uri.query = URI.encode_www_form('access_token' => token)
      index_response = Net::HTTP.get(index_uri)
      index_results = JSON.parse(index_response)

      expect(index_results).to have_key "data"

      sample_application = index_results["data"].sample

      show_uri = URI("https://gis-api.aiesec.org/v2/applications/#{sample_application['id']}")
      show_uri.query = URI.encode_www_form('access_token' => token)
      show_response = Net::HTTP.get(show_uri)
      show_result = JSON.parse(show_response)

      expect(show_result["id"]).to eq sample_application['id']
    end
  end
end
