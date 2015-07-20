class Client
  class << self
    def create!(attrs = {})
      attrs.symbolize_keys!
      add_client(
        attrs.fetch(:contact_email, "foo@localhost.local"),
        attrs.fetch(:key, "valid-cred")
      )
    end

    def find_by(vals = {})
      data.detect{ |c| c["key"] == vals[:key] }
    end

    def first
      data.first
    end

    private

    def data
      Set.new(Sonoma::LocalConfig.data("clients") || [])
    end

    def add_client(email, key)
      clients = data
      clients << { "contact_email" => email, "key" => key }
      Sonoma::LocalConfig.write!("clients", { "data" => clients.to_a })
    end

  end
end
