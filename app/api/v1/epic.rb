module TA
  module API
    module V1
      class Epic < Grape::API
        def get(project_id, id, params={})
          data = Clients::TrackerApi.get("/projects/#{project_id}/epics/#{id}", params: params).body

          Epic.new({ client: client, project_id: project_id }.merge(data))
        end
      end
    end
  end
end
