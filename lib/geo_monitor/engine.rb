# frozen_string_literal: true

require 'rails/all'
require 'faraday'

module GeoMonitor
  ##
  # Top level Rails Engine class
  class Engine < ::Rails::Engine
    require 'geo_monitor/constants'
    require 'geo_monitor/bounding_box'
    require 'geo_monitor/lat_lng_point'
    require 'geo_monitor/requests/wms'

    isolate_namespace GeoMonitor

    GeoMonitor::Engine.config.max_status_per_layer = 5
  end
end
