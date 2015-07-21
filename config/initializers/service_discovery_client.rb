require "service_discovery_client"

ServiceDiscoveryClient.setup_from_service_file(File.join(GG.root, "config", "service_discovery_client.yml"))
ServiceDiscoveryClient.use_typhoeus_engine!
ServiceDiscoveryClient.symbolize_response_body_keys!
