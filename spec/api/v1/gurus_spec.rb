require "app/api"

describe "V1::Gurus" do
  include APIHelpers

  def app
    GG::API::Endpoints
  end

  def create_guru(explicit_params = {})
    Guru.create!({ username: rand.to_s[2..20],
                   user_uuid: generate_uuid
                 }.merge!(explicit_params))
  end

  before(:each) do
    allow(Sonoma::LocalConfig).to receive(:enabled?).with(:AUTHENTICATION).and_return(true)
  end

  describe "GET /:username", :authenticated_user do
    it "returns guru details when Guru is present" do
      user_uuid = generate_uuid
      guru = create_guru({ user_uuid: user_uuid })

      followers_count = rand(10)

      followers_count.times do
        follower = Follower.create!({ user_uuid: generate_uuid,
                                      username: rand.to_s[1..10] }
                                   )

        guru.followers << follower
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
      get("v1/gurus/noname.json")

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
        create_guru
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

  describe "POST /:username/deals", :authenticated_user do
    it "adds deal to guru" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })

      params = { permalink: rand.to_s[2..40] }

      deal_uuid = generate_uuid
      allow(Clients::DealCatalog).to receive(:get_deal).with(params[:permalink]).and_return({ deal: { id: deal_uuid } })

      expect { post "/v1/gurus/#{user_name}/deals", params.to_json }.to change(Deal, :count).by(1)

      guru = Guru.find_by_username(user_name)
      expect(guru.deals.count).to eq(1)
      deal = guru.deals[0]
      expect(deal.permalink).to eq(params[:permalink])
      expect(deal.deal_uuid).to eq(deal_uuid)
    end

    it "does not create new deal record if its already exists" do
      permalink = "a-permalink"
      deal_uuid = generate_uuid
      guru1 = create_guru
      guru1.deals << Deal.create!({ deal_uuid: deal_uuid,
                                    permalink: permalink })

      guru2 = create_guru
      allow(Clients::DealCatalog).to receive(:get_deal).with(permalink).and_return({ deal: { id: deal_uuid } })
      expect { post "/v1/gurus/#{guru2.username}/deals", { permalink: permalink }.to_json }.to change(Deal, :count).by(0)

      expect(Deal.count).to eq(1)
      deal = guru2.deals[0]
      expect(deal.permalink).to eq(permalink)
      expect(deal.deal_uuid).to eq(deal_uuid)
    end

    it "raises 404 if guru is not present" do
      post "v1/gurus/:random/deals", { permalink: "a-permalink" }.to_json

      expect(last_response.status).to eq(404)
    end

    it "raises 400 if deal data is not present in Deal Catalog" do
      user_name = rand.to_s[2..20]
      permalink = "a-permalink"
      create_guru({ username: user_name })

      allow(Clients::DealCatalog).to receive(:get_deal).and_return({})
      post "v1/gurus/#{user_name}/deals", { permalink: permalink }.to_json

      expect(last_response.status).to eq(400)
      expect(response_json[:errors].first[:message]).to eq("Deal is not present for permalink #{permalink}")
    end
  end

  describe "POST /:username/followers", :authenticated_user do
    it "adds follower to guru" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })

      params = { follower_username: rand.to_s[2..40],
                 follower_uuid: generate_uuid
      }

      expect { post "/v1/gurus/#{user_name}/followers", params.to_json }.to change(Follower, :count).by(1)

      guru = Guru.find_by_username(user_name)
      expect(guru.followers.count).to eq(1)
      follower = guru.followers[0]
      expect(follower.username).to eq(params[:follower_username])
      expect(follower.user_uuid).to eq(params[:follower_uuid])
    end

    it "raises 404 if guru is not present" do
      params = { follower_username: rand.to_s[2..40],
                 follower_uuid: generate_uuid
      }
      post "v1/gurus/:random/followers", params.to_json

      expect(last_response.status).to eq(404)
    end
  end
end
