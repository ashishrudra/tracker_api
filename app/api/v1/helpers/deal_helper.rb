module DealHelper
  class << self
    def get_permalink_from_uri(uri)
      uri.split("/")[-1]
    end
  end
end
