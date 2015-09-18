module TA
  module API
    module V1
      class Labels < Grape::API

      def get(project_id, params={})
        data = Clients::TrackerApi.paginate("/projects/#{project_id}/labels", params: params)
        raise Errors::UnexpectedData, 'Array of labels expected' unless data.is_a? Array

        data.map do |label|
          Resources::Label.new({ project_id: project_id }.merge(label))
        end
      end

      def add(project_id, params={})
        data = Clients::TrackerApi.post("/projects/#{project_id}/labels", params: params).body

        Resources::Label.new({ project_id: project_id }.merge(data))
      end
    end
  end
  end
  end