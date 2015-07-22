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

        get "/:userIdentifier" do
          guru = Guru.find_by_username(params[:userIdentifier]) || Guru.find_by_user_uuid!(params[:userIdentifier])
          { guru: Presenters::GuruPresenter.new(guru).present }
        end

        params do
          requires :guru, { type: Hash } do
            requires :username, { allow_blank: false }
            requires :userUuid, { regexp: UUID::REGEX }
            optional :avatar
            optional :pageTitle
            optional :location
            optional :writeup
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
          requires :guru, { type: Hash } do
            optional :avatar
            optional :pageTitle
            optional :location
            optional :writeup
          end
        end

        put "/:username" do
          declared_params = declared(params)[:guru]
          guru_params = declared_params.inject({}) do |result, (k, v)|
            result[k.to_s.underscore.to_sym] = v
            result
          end

          guru = Guru.find_by_username!(params[:username])
          guru.update!(guru_params)
        end

        params do
          requires :username, { allow_blank: false }
          requires :deal, { type: Hash } do
            requires :uri, { allow_blank: false }
            optional :isCover
            optional :notes
          end
        end

        post "/:username/deals" do
          declared_params = declared(params)[:deal]
          deal_params = declared_params.inject({}) do |result, (k, v)|
            result[k.to_s.underscore.to_sym] = v
            result
          end

          Guru.add_deal(params[:username], deal_params)
        end

        params do
          requires :username, { allow_blank: false }
          requires :dealUuid, { allow_blank: false }
          requires :deal, { type: Hash } do
            optional :isCover
            optional :notes
          end
        end

        put "/:username/deals/:dealUuid" do
          declared_params = declared(params)[:deal]
          deal_params = declared_params.inject({}) do |result, (k, v)|
            result[k.to_s.underscore.to_sym] = v
            result
          end

          Guru.update_deal(params[:username], params[:dealUuid], deal_params)
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
