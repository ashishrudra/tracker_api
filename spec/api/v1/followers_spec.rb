require "app/api"

describe "V1::Followers" do
  include APIHelpers

  def app
    GG::API::Endpoints
  end

  def create_guru(explicit_params = {})
    Guru.create!({ username: rand.to_s[2..20],
                   user_uuid: generate_uuid
                 }.merge!(explicit_params))
  end

  def create_deal
    Deal.create({ deal_uuid: generate_uuid,
                  permalink: rand.to_s[2..20]
                })
  end

  before(:each) do
    allow(Sonoma::LocalConfig).to receive(:enabled?).with(:AUTHENTICATION).and_return(true)
  end

  describe "GET /:user_uuid/gurus", :authenticated_user do
    def create_guru_with_followers(followers_count)
      guru = create_guru
      followers_count.times do
        guru.followers << Follower.create!({ user_uuid: generate_uuid })
      end
      guru.reload
    end

    it "returns guru details sort by followers_count" do
      follower_uuid = generate_uuid
      follower = Follower.create!({ user_uuid: follower_uuid })

      guru_count = rand(10)

      guru_count.times do |count|
        follower.gurus << create_guru_with_followers(count)
      end

      get("gurus_api/v1/followers/#{follower_uuid}/gurus.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(guru_count)
      gurus = response_json[:gurus]

      guru_count.times do |count|
        expect(gurus[count][:followersCount]).to eq(guru_count - count)
      end
    end

    it "returns 404 when follower is not present" do
      get("gurus_api/v1/followers/#{generate_uuid}/gurus.json")

      expect(last_response.status).to eq(404)
    end
  end

  describe "GET /:user_uuid/recommended", :authenticated_user do
    it "returns all gurus that I'm not following" do
      follower_uuid = generate_uuid
      follower = Follower.create!({ user_uuid: follower_uuid })
      following, not_following = create_guru, create_guru
      follower.gurus << following

      get("gurus_api/v1/followers/#{follower_uuid}/recommended.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(1)
      gurus = response_json[:gurus]

      expect(response_json[:gurus].first[:userUuid]).to eq(not_following.user_uuid)
    end

    it "limits the results to 8" do
      follower_uuid = generate_uuid
      follower = Follower.create!({ user_uuid: follower_uuid })
      10.times { create_guru }

      get("gurus_api/v1/followers/#{follower_uuid}/recommended.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(8)
    end

    it "returns all gurus when follower is not present" do
      8.times { create_guru }

      get("gurus_api/v1/followers/null/recommended.json")
      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(8)
    end
  end

  describe "GET /:user_uuid/deals", :authenticated_user do
    it "returns 4 random deals" do
      follower_uuid = generate_uuid
      follower = Follower.create!({ user_uuid: follower_uuid })
      3.times do
        guru = create_guru
        5.times { guru.deals << create_deal }
        follower.gurus << guru
      end

      get("gurus_api/v1/followers/#{follower_uuid}/deals.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:deals].count).to be(4)
    end

    it "returns 404 when follower is not present" do
      get("gurus_api/v1/followers/#{generate_uuid}/deals.json")

      expect(last_response.status).to eq(404)
    end
  end

  describe "GET /:userUuid/following/:guruName", :authenticated_user do
    it "returns true if following" do
      follower_uuid = generate_uuid
      guru_name = rand.to_s[2..13]
      follower = Follower.create!({ user_uuid: follower_uuid })
      guru = create_guru({ username: guru_name })
      follower.gurus << guru

      get("gurus_api/v1/followers/#{follower_uuid}/following/#{guru_name}.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:isFollowing]).to be_truthy
    end

    it "returns false if not following" do
      follower_uuid = generate_uuid
      guru_name = rand.to_s[2..13]
      Follower.create!({ user_uuid: follower_uuid })
      create_guru({ username: guru_name })

      get("gurus_api/v1/followers/#{follower_uuid}/following/#{guru_name}.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:isFollowing]).to be_falsy
    end

    it "returns 404 when follower is not present" do
      guru_name = rand.to_s[2..13]
      create_guru({ username: guru_name })
      get("gurus_api/v1/followers/#{generate_uuid}/following/#{guru_name}.json")

      expect(last_response.status).to eq(404)
    end

    it "returns 404 when guru is not present" do
      follower_uuid = generate_uuid
      Follower.create!({ user_uuid: follower_uuid })
      get("gurus_api/v1/followers/#{follower_uuid}/following/not_a_guru.json")

      expect(last_response.status).to eq(404)
    end
  end
end
