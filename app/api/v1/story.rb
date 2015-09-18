module TA
  module API
    module V1
      class Story < Grape::API

      def get(project_id, id, params={})
        data = Clients::TrackerApi.get("/projects/#{project_id}/stories/#{id}", params: params).body

        Resources::Story.new({ client: client, project_id: project_id }.merge(data))
      end

      def get_story(story_id, params={})
        data = Clients::TrackerApi.get("/stories/#{story_id}", params: params).body

        Resources::Story.new({ client: client }.merge(data))
      end

      def create(project_id, params={})
        data = Clients::TrackerApi.post("/projects/#{project_id}/stories", params: params).body

        Resources::Story.new({ client: client }.merge(data))
      end

      def update(story, params={})
        data = Clients::TrackerApi.put("/projects/#{story.project_id}/stories/#{story.id}", params: params).body

        story.attributes = data
      end
    end
  end
  end
  end
