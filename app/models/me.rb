
    class Me
      include HasId

      attribute :name, String
      attribute :initials, String
      attribute :username, String
      attribute :api_token, String
      attribute :has_google_identity, Boolean
      attribute :project_ids, Array[Integer]
      attribute :email, String
      attribute :kind, String
    end
