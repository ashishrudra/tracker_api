module TA
  module API
    module V1
      class Projects < Grape::API

        get "/" do
         { projects: Clients::TrackerApi.new.paginate('/projects') }
        end

        get "/:id" do
          { project: Clients::TrackerApi.new.get("/projects/" + params.id) }
        end
      end
    end
  end
end