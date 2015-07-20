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
      end
    end
  end
end
