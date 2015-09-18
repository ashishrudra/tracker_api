module TA
  module API
    module V1
      class Tasks < Grape::API

      def get(project_id, story_id, params={})
        data = Clients::TrackerApi.paginate("/projects/#{project_id}/stories/#{story_id}/tasks", params: params)

        data.map do |task|
          Resources::Task.new({ story_id: story_id }.merge(task))
        end
      end
    end
  end
  end
  end
