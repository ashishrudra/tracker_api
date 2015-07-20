require "app/api"

describe "V1::Ambassadors" do
  include APIHelpers

  def app
    GA::API::Endpoints
  end

  describe "/:username" do
    it "returns ambassador details when ambassador is present" do
      user_uuid = generate_uuid
      ambassador = Ambassador.create!({ username: "johndoe",
                                        user_uuid: user_uuid,
                                        email: "johndoe@groupon.com" })

      followers_count = rand(10)

      followers_count.times do 
        Follower.create!(ambassador_id: ambassador.id,
                         user_uuid: generate_uuid,
                         username: rand.to_s[1..10]
                        )
      end

      deals_count = rand(10)

      deals_count.times do 
        deal = Deal.create!(permalink: rand.to_s[2..20],
                            deal_uuid: generate_uuid)

        ambassador.deals << deal
      end

      get("v1/ambassadors/#{ambassador.username}.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:uuid]).to eq(ambassador.id)
      expect(response_json[:email]).to eq("johndoe@groupon.com")
      expect(response_json[:user_uuid]).to eq(user_uuid)
      expect(response_json[:followers_count]).to eq(followers_count)
      expect(response_json[:deals].count).to be(deals_count)
    end

    it "returns 404 when ambassador is not present" do
      get("v1/amabassador/noname.json")

      expect(last_response.status).to eq(404)
    end
  end

  describe "/" do
    it "returns array of ambassadors" do
      ambassadors_count = rand(10)

      ambassadors_count.times do
      ambassador = Ambassador.create!({ username: rand.to_s[1..10],
                                        user_uuid: generate_uuid,
                                        email: "johndoe@groupon.com" })
      end

      get("v1/ambassadors.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:ambassadors].count).to be(ambassadors_count)
    end
  end
end
