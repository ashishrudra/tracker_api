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

  before(:each) do
    allow(Sonoma::LocalConfig).to receive(:enabled?).with(:AUTHENTICATION).and_return(true)
  end

  describe "GET /:user_uuid/gurus", :authenticated_user do
    it "returns guru details when Guru is present" do
      follower_uuid = generate_uuid
      follower = Follower.create!({ user_uuid: follower_uuid,
                                    username: rand.to_s[2..18] })

      guru_count = rand(10)

      guru_count.times do
        follower.gurus << create_guru
      end

      get("v1/followers/#{follower_uuid}/gurus.json")

      expect(last_response.status).to eq(200)
      expect(response_json[:gurus].count).to be(guru_count)
    end

    it "returns 404 when follower is not present" do
      get("v1/followers/#{generate_uuid}/gurus.json")

      expect(last_response.status).to eq(404)
    end
  end
end
