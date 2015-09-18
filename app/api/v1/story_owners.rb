module TA
  module API
    module V1
      class StoryOwners < Grape::API

      def get(project_id, story_id, params={})
        data = Clients::TrackerApi.paginate("/projects/#{project_id}/stories/#{story_id}/owners", params: params)
        raise Errors::UnexpectedData, 'Array of comments expected' unless data.is_a? Array

        data.map do |owner|
          Resources::Person.new({ story_id: story_id }.merge(owner))
        end
      end
    end
  end
end

  end