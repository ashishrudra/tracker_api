require "app/api_builder"

module APIHelpers
  include Rack::Test::Methods

  def app
    GA::API::BUILDER
  end

  def self.included(base)
    base.before(:each) do
      header "Content-Type", "application/json"
    end
  end

  def response_json
    JSON.parse(last_response.body, { symbolize_names: true })
  end

  def expect_success_response
    expect(last_response.status).to eq(200)
  end

  def expect_created_response
    expect(last_response.status).to eq(201)
  end

  def expect_bad_request(error_message = nil)
    expect(last_response.status).to eq(400)
    expect(json[:error]).to include(error_message) if error_message
  end

  def expect_not_found_response
    expect(last_response.status).to eq(404)
  end

  def expect_unauthorized_response
    expect(last_response.status).to eq(401)
  end
end

RSpec.configure do |config|
  config.include APIHelpers, { type: :api }

  config.before(:each, :authenticated_user) do
    Client.create!
    header("Authorization", "GGV1 #{Client.first['key']}")
  end
end
