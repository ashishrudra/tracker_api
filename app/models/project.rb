class Project
      include HasId

      attribute :client

      attribute :account_id, Integer
      attribute :atom_enabled, Boolean
      attribute :bugs_and_chores_are_estimatable, Boolean
      attribute :current_iteration_number, Integer
      attribute :current_velocity, Integer
      attribute :description, String
      attribute :enable_following, Boolean
      attribute :enable_incoming_emails, Boolean
      attribute :enable_planned_mode, Boolean
      attribute :enable_tasks, Boolean
      attribute :epic_ids, Array[Integer]
      attribute :epics, Array[Epic]
      attribute :has_google_domain, Boolean
      attribute :initial_velocity, Integer
      attribute :iteration_length, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[Label]
      attribute :name, String
      attribute :number_of_done_iterations_to_show, Integer
      attribute :point_scale, String
      attribute :point_scale_is_custom, Boolean
      attribute :profile_content, String
      attribute :public, Boolean
      attribute :start_date, DateTime
      attribute :start_time, DateTime
      attribute :updated_at, DateTime
      attribute :velocity_averaged_over, Integer
      attribute :version, Integer
      attribute :week_start_day, String

      def label_list
        @label_list ||= labels.collect(&:name).join(',')
      end

      def label_ids
        @label_ids ||= labels.collect(&:id).join(',')
      end

      def labels(params = {})
        if @labels && @labels.any?
          @labels
        else
          @labels = Endpoints::Labels.new(client).get(id, params)
        end
      end

      def epics(params={})
        raise ArgumentError, 'Expected @epics to be an Array' unless @epics.is_a? Array
        return @epics unless @epics.empty?

        @epics = Endpoints::Epics.new(client).get(id, params)
      end


      def stories(params={})
        Endpoints::Stories.new(client).get(id, params)
      end

      def story(story_id, params={})
        Endpoints::Story.new(client).get(id, story_id, params)
      end

      def create_story(params)
        Endpoints::Story.new(client).create(id, params)
      end

      def epic(epic_id, params={})
        Endpoints::Epic.new(client).get(id, epic_id, params)
      end

      def create_epic(params)
        Endpoints::Epic.new(client).create(id, params)
      end
    end
