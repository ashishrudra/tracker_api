require "app/models/task"
class Story
      include HasId

      attribute :client

      attribute :accepted_at, DateTime
      attribute :created_at, DateTime
      attribute :current_state, String
      attribute :deadline, DateTime
      attribute :description, String
      attribute :estimate, Float
      attribute :integration_id, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[Label], :default => []
      attribute :name, String
      attribute :owned_by, Person
      attribute :owner_ids, Array[Integer]
      attribute :owners, Array[Person], :default => []
      attribute :project_id, Integer
      attribute :requested_by, Person
      attribute :requested_by_id, Integer
      attribute :story_type, String
      attribute :task_ids, Array[Integer]
      attribute :tasks, Array[Task], :default => []
      attribute :updated_at, DateTime
      attribute :url, String


      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :name
        property :description
        property :story_type
        property :current_state
        property :estimate
        property :accepted_at
        property :deadline
        property :requested_by_id
        property :owner_ids
        collection :labels, class: Label, decorator: Label::UpdateRepresenter, render_empty: true
        property :integration_id
        property :external_id
      end

      def label_list
        @label_list ||= labels.collect(&:name).join(',')
      end

      def tasks(params = {})
        if params.blank? && @tasks.any?
          @tasks
        else
          @tasks = Endpoints::Tasks.new(client).get(project_id, id, params)
        end
      end

      def owners(params = {})
        if params.blank? && @owners.any?
          @owners
        else
          @owners = Endpoints::StoryOwners.new(client).get(project_id, id, params)
        end
      end


      def create_task(params)
        Endpoints::Task.new(client).create(project_id, id, params)
      end

      # Save changes to an existing Story.
      def save
        raise ArgumentError, 'Can not update a story with an unknown project_id.' if project_id.nil?

        Endpoints::Story.new(client).update(self, UpdateRepresenter.new(self))
      end
    end
