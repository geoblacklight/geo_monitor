require 'rails/all'
require 'faraday'
require 'geo_monitor/bounding_box'
require 'geo_monitor/lat_lng_point'
require 'geo_monitor/requests/wms'

module GeoMonitor
  R = 6_378_137 # Radius of Earth in meters
  DEGREES_IN_CIRCLE = 360.0

  ##
  # Top level Rails Engine class
  class Engine < ::Rails::Engine
    isolate_namespace GeoMonitor
  end
end
