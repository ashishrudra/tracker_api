require "app/api"

describe "V1::Gurus" do
  include APIHelpers

  def app
    GG::API::Endpoints
  end

  describe "GET /:username", :authenticated_user do
    it "returns guru details when Guru is present" do
      user_uuid = generate_uuid
      guru = Guru.create!({ username: "johndoe",
                            user_uuid: user_uuid
                          })

      followers_count = rand(10)

      followers_count.times do
        Follower.create!({ guru_id: guru.id,
                           user_uuid: generate_uuid,
                           username: rand.to_s[1..10] }
                        )
      end

      deals_count = rand(10)

      deals_count.times do
        deal = Deal.create!({ permalink: rand.to_s[2..20],
                              deal_uuid: generate_uuid })

        guru.deals << deal
      end

      get("v1/gurus/#{guru.username}.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:uuid]).to eq(guru.id)
      expect(response_json[:user_uuid]).to eq(user_uuid)
      expect(response_json[:followers_count]).to eq(followers_count)
      expect(response_json[:deals].count).to be(deals_count)
    end

    it "returns 404 when guru is not present" do
      get("v1/amabassador/noname.json")

      expect(last_response.status).to eq(404)
    end
  end

  context "GET /v1/markup_schedules", "when not authenticated" do
    it "returns a 401 error" do
      get("v1/gurus.json")

      expect_unauthorized_response
    end
  end

  describe "GET /", :authenticated_user do
    it "returns array of gurus" do
      gurus_count = rand(10)

      gurus_count.times do
        Guru.create!({ username: rand.to_s[1..10],
                       user_uuid: generate_uuid })
      end

      get("v1/gurus.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(gurus_count)
    end
  end

  describe "POST /", :authenticated_user do
    it "creates a guru" do
      user_name = rand.to_s[2..20]
      params = {
        username: user_name,
        user_uuid: generate_uuid
      }

      expect { post "/v1/gurus", params.to_json }.to change(Guru, :count).by(1)

      guru = Guru.find_by_username(user_name)
      expect(guru.user_uuid).to eq(params[:user_uuid])
    end

    it "raises 400 if inputs are not valid/missing" do
      post "v1/gurus"

      expect(last_response.status).to eq(400)
    end
  end
end
