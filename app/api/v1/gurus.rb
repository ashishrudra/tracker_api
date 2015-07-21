module GG
  module API
    module V1
      class Gurus < Grape::API
        get "/" do
          gurus = Guru.all

          { gurus: gurus.map do |guru|
            Presenters::GuruPresenter.new(guru).present
          end
          }
        end

        get "/:username" do
          guru = Guru.find_by_username!(params[:username])
          { guru: Presenters::GuruPresenter.new(guru).present }
        end

        params do
          requires :guru, { type: Hash } do
            requires :username, { allow_blank: false }
            requires :userUuid, { regexp: UUID::REGEX }
          end
        end

        post "/" do
          declared_params = declared(params)[:guru]
          guru_params = declared_params.inject({}) do |result, (k, v)|
            result[k.to_s.underscore.to_sym] = v
            result
          end

          Guru.create!(guru_params)
        end

        params do
          requires :username, { allow_blank: false }
          requires :dealUri, { allow_blank: false }
        end

        post "/:username/deals" do
          Guru.add_deal(params)
        end

        params do
          requires :username, { allow_blank: false }
          requires :follower, { type: Hash } do
            requires :username, { allow_blank: false }
            requires :userUuid, { regexp: UUID::REGEX }
          end
        end

        post "/:username/followers" do
          declared_params = declared(params)[:follower]
          follower_params = declared_params.inject({}) do |result, (k, v)|
            result[k.to_s.underscore.to_sym] = v
            result
          end

          Guru.add_follower(params[:username], follower_params)
        end
      end
    end
  end
end
