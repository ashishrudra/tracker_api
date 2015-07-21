Typhoeus.on_complete do |response|
  if response.success?
    # huray!
  elsif response.timed_out?
    raise(Clients::Errors::Timeout, response)
  else
    raise(Clients::Errors::Response, response)
  end
end
