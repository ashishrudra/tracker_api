module Authentication
  AUTH_HEADER = "HTTP_AUTHORIZATION".freeze

  AUTHENTICATOR = lambda do |request|
    _scheme, client_id = request.env[AUTH_HEADER].to_s.split(" ")
    client_id && MarketPricing.fetch_config(:clients).fetch(client_id, false)
  end.freeze
end
