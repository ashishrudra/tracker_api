require "app/api"

describe GG::API do
  include Rack::Test::Methods

  def app
    GG::API::Endpoints
  end

  context "authentication" do
    def request(auth_header = nil)
      header "AuTHorIZAtION", auth_header
      get "/ping"
    end

    it "is meaningless when the feature is off" do
      allow(Sonoma::LocalConfig).to receive(:enabled?).with(:AUTHENTICATION).and_return(false)
      request(:any_auth)
      expect(last_response).to be_ok
    end

    context "when enabled" do
      before(:each) do
        allow(Sonoma::LocalConfig).to receive(:enabled?).with(:AUTHENTICATION).and_return(true)
      end

      it "returns 401 when clientId is not passed" do
        request
        expect(last_response.status).to eq(401)
      end

      it "returns 401 when clientId is not valid" do
        request("GGV1 not-valid")
        expect(last_response.status).to eq(401)
      end

      it "passes through request with valid clientIds" do
        Client.create!({ contact_email: "foo@localhost.local", key: "valid-cred" })

        request("GGV1 valid-cred")
        expect(last_response.status).to eq(200)
      end
    end
  end
end
