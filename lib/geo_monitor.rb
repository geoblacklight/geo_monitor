require "geo_monitor/engine"

module GeoMonitor
  # A simple structure to conform to Faraday::Response
  FailedResponse = Struct.new(:env, :status, :headers)
end
