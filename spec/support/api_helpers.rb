require "app/api_builder"

module APIHelpers
  include Rack::Test::Methods

  def app
    GMO::API::BUILDER
  end

  def self.included(base)
    base.before(:each) do
      header "Content-Type", "application/json"
    end
  end

  def response_json
    JSON.parse(last_response.body, { symbolize_names: true })
  end
end
