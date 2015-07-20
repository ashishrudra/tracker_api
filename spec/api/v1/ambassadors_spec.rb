require "app/api"

describe "V1::Ambassadors" do
  include APIHelpers

  def app
    GA::API::Endpoints
  end

  describe ":/" do
    it "returns array of ambassadors when no ambassador is present" do
      Ambassador.create!({ username: "johndoe",
                           user_uuid: generate_uuid,
                           email: "johndoe@groupon.com" })

      get("v1/ambassadors.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:ambassadors].count).to be(1)
    end
  end
end
