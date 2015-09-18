class Epic
      include HasId

      attribute :client

      attribute :created_at, DateTime
      attribute :description, String
      attribute :kind, String
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
      attribute :url, String
end
