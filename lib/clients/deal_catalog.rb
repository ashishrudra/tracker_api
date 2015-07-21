module Clients
  module DealCatalog
    SERVICE = "deal-catalog".freeze
    ENDPOINT = "v1.deals.lookupId.lookup_id".freeze

    class << self
      def get_deal(permalink)
        response = ServiceDiscoveryClient::Request.fire!(SERVICE, ENDPOINT, { permalink: permalink })
        response.body!
      end
    end
  end
end
