module Clients
  describe DealCatalog do
    describe "::get_deal" do
      it "returns deal" do
        endpoint = %r{http://deal-catalog.test/deal_catalog/v1/deals/lookupId}
        body = { deal:
                    {
                      id: generate_uuid
                    }
        }
        request = stub_request(:get, endpoint).and_return({ body: body.to_json })

        response = DealCatalog.get_deal("permalink")

        expect(request.with({ query: hash_including({ clientId: "test-client-id" }) })).to have_been_made
        expect(response).to eq(body)
      end
    end
  end
end
