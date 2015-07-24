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

  describe "GET /:userIdentifier", :authenticated_user do
    it "returns guru details when Guru is present" do
      user_uuid = generate_uuid
      guru = create_guru({ user_uuid: user_uuid,
                           page_title: "My Page",
                           place: "chicago",
                           avatar: "my-avatar.jpg" })

      followers_count = rand(10)

      followers_count.times do
        guru.followers << Follower.create!({ user_uuid: generate_uuid })
      end

      deals_count = rand(10)

      deals_count.times do
        deal = Deal.create!({ permalink: rand.to_s[2..20],
                              deal_uuid: generate_uuid })

        guru.deals << deal
      end

      get("gurus_api/v1/gurus/#{guru.username}")
      expect(last_response.status).to eq(200)
      guru_response = response_json[:guru]
      expect(guru_response[:id]).to eq(guru.id)
      expect(guru_response[:userUuid]).to eq(user_uuid)
      expect(guru_response[:followersCount]).to eq(followers_count)
      expect(guru_response[:deals].count).to be(deals_count)
      expect(guru_response[:pageTitle]).to eq(guru.page_title)
      expect(guru_response[:place]).to eq(guru.place)
      expect(guru_response[:avatar]).to eq(guru.avatar)
    end

    it "returns guru details for given guru user_uuid" do
      user_uuid = generate_uuid
      user_name = rand.to_s[2..15]
      guru = create_guru({ user_uuid: user_uuid,
                           username: user_name })

      get("gurus_api/v1/gurus/#{guru.user_uuid}")

      expect(last_response.status).to eq(200)
      guru_response = response_json[:guru]
      expect(guru_response[:id]).to eq(guru.id)
      expect(guru_response[:username]).to eq(user_name)
    end

    it "returns 404 when guru is not present" do
      get("gurus_api/v1/gurus/noname")

      expect(last_response.status).to eq(404)
    end
  end

  context "GET /gurus_api/v1/gurus", "when not authenticated" do
    it "returns a 401 error" do
      get("gurus_api/v1/gurus")

      expect_unauthorized_response
    end
  end

  describe "GET /", :authenticated_user do
    def create_guru_with_followers(followers_count)
      guru = create_guru
      followers_count.times do
        guru.followers << Follower.create!({ user_uuid: generate_uuid })
      end
      guru.reload
    end

    it "returns array of gurus" do
      gurus_count = rand(10)

      gurus_count.times do
        create_guru
      end

      get("gurus_api/v1/gurus")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(gurus_count)
    end

    it "returns array of gurus sort by followers count" do
      guru1 = create_guru_with_followers(10)
      guru2 = create_guru_with_followers(30)
      guru3 = create_guru_with_followers(20)

      get("gurus_api/v1/gurus")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(3)
      expect(response_json[:gurus].first[:id]).to eq(guru2.id)
      expect(response_json[:gurus].second[:id]).to eq(guru3.id)
      expect(response_json[:gurus].last[:id]).to eq(guru1.id)
    end

    it "error handling" do
      allow(Guru).to receive(:all).and_raise(StandardError.new)
      get("gurus_api/v1/gurus")

      expect(last_response.status).to eq(500)
      expect(response_json[:errors].count).to be(1)
      expect(response_json[:errors][0][:code]).to be
      expect(response_json[:errors][0][:description]).to be
      expect(response_json[:errors][0][:backtrace]).to be
    end
  end

  describe "POST /", :authenticated_user do
    it "creates a guru" do
      user_name = rand.to_s[2..20]
      params = { guru:
                 {
                   username: user_name,
                   userUuid: generate_uuid,
                   avatar: "my_image.jpg",
                   pageTitle: "hello world",
                   place: "chicago",
                   writeup: "my writeup"
                 }
      }

      expect { post "/gurus_api/v1/gurus", params.to_json }.to change(Guru, :count).by(1)

      # API Checks
      guru = response_json[:guru]
      expect(guru[:userUuid]).to eq(params[:guru][:userUuid])
      expect(guru[:avatar]).to eq("my_image.jpg")
      expect(guru[:pageTitle]).to eq("hello world")
      expect(guru[:place]).to eq("chicago")
      expect(guru[:writeup]).to eq("my writeup")

      # DB Checks
      guru = Guru.find_by_username(user_name)
      expect(guru.user_uuid).to eq(params[:guru][:userUuid])
      expect(guru.avatar).to eq("my_image.jpg")
      expect(guru.page_title).to eq("hello world")
      expect(guru.place).to eq("chicago")
      expect(guru.writeup).to eq("my writeup")
    end

    it "saves underscore in place of space in database" do
      user_name = "AA BB cC dd"
      user_uuid = generate_uuid
      params = { guru:
                     {
                         username: user_name,
                         userUuid: user_uuid,
                         avatar: "my_image.jpg",
                         pageTitle: "hello world",
                         place: "chicago",
                         writeup: "my writeup"
                     }
      }

      expect { post "/gurus_api/v1/gurus", params.to_json }.to change(Guru, :count).by(1)

      # API Checks
      guru = response_json[:guru]
      expect(guru[:userUuid]).to eq(user_uuid)
      expect(guru[:username]).to eq("AA_BB_cC_dd")
      expect(guru[:avatar]).to eq("my_image.jpg")
      expect(guru[:pageTitle]).to eq("hello world")
      expect(guru[:place]).to eq("chicago")
      expect(guru[:writeup]).to eq("my writeup")

      # DB Checks
      guru = Guru.find_by_user_uuid(user_uuid)
      expect(guru.username).to eq("AA_BB_cC_dd")
      expect(guru.avatar).to eq("my_image.jpg")
      expect(guru.page_title).to eq("hello world")
      expect(guru.place).to eq("chicago")
      expect(guru.writeup).to eq("my writeup")
    end

    it "raises 400 if inputs are not valid/missing" do
      post "gurus_api/v1/gurus"

      expect(last_response.status).to eq(400)
    end
  end

  describe "PUT /", :authenticated_user do
    it "updates a guru" do
      user_name = rand.to_s[2..20]
      guru = create_guru({ username: user_name })
      params = { guru:
                 { avatar: "my_avatar.jpg",
                   pageTitle: "my page",
                   place: "chicago",
                   writeup: "my writeup"
                 }
      }

      expect(guru.avatar).to be_blank
      expect(guru.page_title).to be_blank
      expect(guru.place).to be_blank
      expect(guru.writeup).to be_blank

      put("/gurus_api/v1/gurus/#{user_name}", params.to_json)

      guru.reload
      expect(guru.avatar).to eq("my_avatar.jpg")
      expect(guru.page_title).to eq("my page")
      expect(guru.place).to eq("chicago")
      expect(guru.writeup).to eq("my writeup")
    end

    it "raises 404 if guru is not present" do
      put "gurus_api/v1/not-a-guru"

      expect(last_response.status).to eq(404)
    end

    it "does not update user_uuid or username" do
      user_name = rand.to_s[2..20]
      user_uuid = generate_uuid
      guru = create_guru({ username: user_name,
                           user_uuid: user_uuid })
      params = { guru:
                 { user_name: "updated",
                   user_uuid: generate_uuid,
                   avatar: "my_avatar.jpg" }
      }

      put("/gurus_api/v1/gurus/#{user_name}", params.to_json)

      guru.reload
      expect(guru.avatar).to eq("my_avatar.jpg")
      expect(guru.user_uuid).to eq(user_uuid)
      expect(guru.username).to eq(user_name)
    end
  end

  describe "POST /:username/deals", :authenticated_user do
    before(:each) do
      @permalink = rand.to_s[2..15]
      deal_uri = "http://www.staging.groupon.com/deals/#{@permalink}"
      @deal_params = { uri: deal_uri }
    end

    it "adds deal to guru" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })

      deal_uuid = generate_uuid
      allow(Clients::DealCatalog).to receive(:get_deal).with(@permalink).and_return({ deal: { id: deal_uuid } })
      params = { deal: @deal_params.merge!({ isCover: true, notes: "my favorite deal" }) }

      expect { post "/gurus_api/v1/gurus/#{user_name}/deals", params.to_json }.to change(Deal, :count).by(1)

      guru = Guru.find_by_username(user_name)
      expect(guru.deals.count).to eq(1)
      guru_deal = guru.guru_deals.first
      deal = guru_deal.deal
      expect(deal.permalink).to eq(@permalink)
      expect(deal.deal_uuid).to eq(deal_uuid)
      expect(guru_deal.is_cover).to be_truthy
      expect(guru_deal.notes).to eq("my favorite deal")
    end

    it "does not create new deal record if its already exists" do
      deal_uuid = generate_uuid
      guru1 = create_guru
      guru1.deals << Deal.create!({ deal_uuid: deal_uuid,
                                    permalink: @permalink })

      guru2 = create_guru
      allow(Clients::DealCatalog).to receive(:get_deal).with(@permalink).and_return({ deal: { id: deal_uuid } })
      expect { post "/gurus_api/v1/gurus/#{guru2.username}/deals", { deal: @deal_params }.to_json }.to change(Deal, :count).by(0)

      expect(Deal.count).to eq(1)
      deal = guru2.deals[0]
      expect(deal.permalink).to eq(@permalink)
      expect(deal.deal_uuid).to eq(deal_uuid)
    end

    it "raises 404 if guru is not present" do
      post "gurus_api/v1/gurus/:random/deals", { deal: @deal_params }.to_json

      expect(last_response.status).to eq(404)
    end

    it "raises 400 if deal data is not present in Deal Catalog" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })

      allow(Clients::DealCatalog).to receive(:get_deal).and_return({})
      post "gurus_api/v1/gurus/#{user_name}/deals", { deal: @deal_params }.to_json

      expect(last_response.status).to eq(400)
      expect(response_json[:errors].first[:message]).to eq("Deal is not present for permalink #{@permalink}")
    end

    it "raises a 400 if a groupon url is not provided" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })
      bad_uri = 'http://someotherplace.com/foo/bar'
      deal_params = { uri: bad_uri }

      expect(Clients::DealCatalog).to_not receive(:get_deal)
      post "gurus_api/v1/gurus/#{user_name}/deals", { deal: deal_params }.to_json

      expect(last_response.status).to eq(400)
      expect(response_json[:errors].first[:message]).to eq("Please provide a valid Groupon Staging URL.")
    end
  end

  describe "PUT /:username/deals/:dealUuid", :authenticated_user do
    it "updates guru's deal" do
      user_name = rand.to_s[2..20]
      deal_uuid = generate_uuid
      guru = create_guru({ username: user_name })
      deal = Deal.create!({ deal_uuid: deal_uuid, permalink: "a-permalink" })
      guru.deals << deal

      guru_deal = guru.guru_deals.first
      expect(guru_deal.is_cover).to be_falsy
      expect(guru_deal.notes).to be_blank

      deal_params = { isCover: true, notes: "my favorite deal" }

      put("/gurus_api/v1/gurus/#{user_name}/deals/#{deal_uuid}", { deal: deal_params }.to_json)

      guru.reload

      guru_deal = guru.guru_deals.first
      deal = guru_deal.deal
      expect(deal.deal_uuid).to eq(deal_uuid)
      expect(guru_deal.is_cover).to be_truthy
      expect(guru_deal.notes).to eq("my favorite deal")
    end

    it "keeps only one cover deal" do
      user_name = rand.to_s[2..20]
      deal_uuid = generate_uuid
      guru = create_guru({ username: user_name })
      deal1 = Deal.create!({ deal_uuid: deal_uuid, permalink: "permalink_1" })
      deal2 = Deal.create!({ deal_uuid: generate_uuid, permalink: "permalink_2" })
      guru_deal1 = GuruDeal.create!({ guru: guru, deal: deal1 })
      guru_deal2 = GuruDeal.create!({ guru: guru, deal: deal2, is_cover: true })

      expect(guru_deal1.is_cover).to be_falsy
      expect(guru_deal2.is_cover).to be_truthy

      deal_params = { isCover: true, notes: "my favorite deal" }

      put("/gurus_api/v1/gurus/#{user_name}/deals/#{deal_uuid}", { deal: deal_params }.to_json)

      expect(guru_deal1.reload.is_cover).to be_truthy
      expect(guru_deal2.reload.is_cover).to be_falsy
    end

    it "raises 404 if guru is not present" do
      put "gurus_api/v1/gurus/:random/deals/:random", { deal: {} }.to_json

      expect(last_response.status).to eq(404)
    end
  end

  describe "POST /:username/followers", :authenticated_user do
    it "adds follower to guru" do
      user_name = rand.to_s[2..20]
      create_guru({ username: user_name })

      params = { follower:
                 {
                   userUuid: generate_uuid
                 }
      }

      expect { post "/gurus_api/v1/gurus/#{user_name}/followers", params.to_json }.to change(Follower, :count).by(1)

      guru = Guru.find_by_username(user_name)
      expect(guru.followers.count).to eq(1)
      expect(guru.followers_count).to eq(1)
      follower = guru.followers[0]
      expect(follower.user_uuid).to eq(params[:follower][:userUuid])
    end

    it "doesn't add follower entry if already existing" do
      user_name = rand.to_s[2..20]
      user_uuid = generate_uuid
      create_guru({ username: user_name })

      params = { follower:
                   {
                     userUuid: user_uuid
                   }
      }

      expect { post "/gurus_api/v1/gurus/#{user_name}/followers", params.to_json }.to change(Follower, :count).by(1)

      guru = Guru.find_by_username(user_name)
      followers_count = guru.followers.count

      post "/gurus_api/v1/gurus/#{user_name}/followers", params.to_json
      guru.reload
      expect(guru.followers.count).to eq(followers_count)
      expect(guru.followers_count).to eq(followers_count)
    end

    it "raises 404 if guru is not present" do
      params = { follower:
                  {
                    userUuid: generate_uuid
                  }
      }

      post "gurus_api/v1/gurus/:random/followers", params.to_json

      expect(last_response.status).to eq(404)
    end
  end

  describe "DELETE /:username/followers/:followerUuid", :authenticated_user do
    it "removes follower from guru" do
      user_name = rand.to_s[2..20]
      follower_uuid = generate_uuid
      guru = create_guru({ username: user_name })
      follower = Follower.create!({ user_uuid: follower_uuid })
      guru.followers << follower
      expect(guru.reload.followers_count).to be(1)

      expect { post "/gurus_api/v1/gurus/#{user_name}/followers/#{follower_uuid}" }.to change(GuruFollower, :count).by(-1)

      guru.reload
      expect(guru.followers.count).to eq(0)
    end

    it "doesn't delete other followers entry" do
      user_name = rand.to_s[2..20]
      follower_uuid = generate_uuid
      guru = create_guru({ username: user_name })
      follower = Follower.create!({ user_uuid: follower_uuid })
      guru.followers << follower
      other_followers = rand(20)
      other_followers.times do
        guru.followers << Follower.create!({ user_uuid: generate_uuid })
      end

      expect(guru.reload.followers_count).to be(other_followers + 1)

      expect { post "/gurus_api/v1/gurus/#{user_name}/followers/#{follower_uuid}" }.to change(GuruFollower, :count).by(-1)

      guru.reload
      expect(guru.followers.count).to eq(other_followers)
    end

    it "raises 404 if guru is not present" do
      post "/gurus_api/v1/gurus/not_a_guru/followers/#{generate_uuid}"

      expect(last_response.status).to eq(404)
    end

    it "raises 404 if follower is not present" do
      guru = create_guru
      post "/gurus_api/v1/gurus/#{guru.username}/followers/#{generate_uuid}"

      expect(last_response.status).to eq(404)
    end
  end
end
