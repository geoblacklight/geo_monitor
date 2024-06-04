# frozen_string_literal: true

require 'geo_monitor/engine'

# Main module for the engine
module GeoMonitor
  extend ActiveSupport::Autoload

  # A simple structure to conform to Faraday::Response
  FailedResponse = Struct.new(:env, :status, :headers)
end
