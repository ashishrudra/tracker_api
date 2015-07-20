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
          guru = Guru.find_by_username params[:username]
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
      end
    end
  end
end
