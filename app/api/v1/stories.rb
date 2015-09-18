module TA
  module API
    module V1
      class Stories < Grape::API

      def get(project_id, params={})
        data = Clients::TrackerApi.paginate("/projects/#{project_id}/stories", params: params)

        data.map do |story|
          Resources::Story.new({ client: client, project_id: project_id }.merge(story))
        end
      end
    end
  end
  end
end
