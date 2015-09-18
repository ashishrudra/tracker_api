module TA
  module API
    module V1
      class Epic < Grape::API

      def get(project_id, params={})
        data = Clients::TrackerApi.paginate("/projects/#{project_id}/epics", params: params)
        raise Errors::UnexpectedData, 'Array of epics expected' unless data.is_a? Array

        data.map do |epic|
          Resources::Epic.new({ project_id: project_id }.merge(epic))
        end
      end
    end
  end
  end
end
