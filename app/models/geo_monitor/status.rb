module GeoMonitor
  class Status < ApplicationRecord
    belongs_to :layer, counter_cache: true, touch: true
    before_create :limit_by_layer

    ##
    # Limits the number of statuses per layer to prevent a ballooing database
    def limit_by_layer
      statuses_by_layer = self.class.where(layer: layer).count
      max = ::GeoMonitor::Engine.config.max_status_per_layer
      self.class
          .where(layer: layer)
          .last(statuses_by_layer - max + 1)
          .map(&:destroy) if statuses_by_layer >= max
    end

    ##
    # @param [Faraday::Resposne] response
    # @param [GeoMonitor::Layer] layer
    # @param [Float] time
    def self.from_response(response, layer, time)
      create(
        res_time: time.to_f,
        res_code: response.status,
        submitted_query: response.env[:url].to_s,
        layer: layer,
        res_headers: response.headers
      )
    end
  end
end
