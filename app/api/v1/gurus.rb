module GG
  module API
    module V1
      class Gurus < Grape::API
        get "/" do
          gurus = Guru.all

          { gurus: gurus.each do |guru|
            Presenters::GuruPresenter.new(guru).present
          end
          }
        end

        get "/:username" do
          guru = Guru.find_by_username!(params[:username])
          Presenters::GuruPresenter.new(guru).present
        end

        params do
          requires :username, { allow_blank: false }
          requires :user_uuid, { regexp: UUID::REGEX }
        end

        post "/" do
          Guru.create!({ username: params.username,
                         user_uuid: params.user_uuid }
                      )
        end

        params do
          requires :username, { allow_blank: false }
          requires :permalink, { allow_blank: false }
        end

        post "/:username/deals" do
          Guru.add_deal(params)
        end

        params do
          requires :username, { allow_blank: false }
          requires :follower_username, { allow_blank: false }
          requires :follower_uuid, { regexp: UUID::REGEX }
        end

        post "/:username/followers" do
          Guru.add_follower(params)
        end
      end
    end
  end
end
