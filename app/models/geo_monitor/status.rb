# frozen_string_literal: true

module GeoMonitor
  # A record of availability for a single layer at a single point in time
  class Status < ApplicationRecord
    belongs_to :layer, counter_cache: true, touch: true
    before_create :limit_by_layer

    ##
    # Limits the number of statuses per layer to prevent a ballooing database
    def limit_by_layer
      statuses_by_layer = self.class.where(layer:).count
      max = ::GeoMonitor::Engine.config.max_status_per_layer
      return unless statuses_by_layer >= max

      self.class
          .where(layer:)
          .first(statuses_by_layer - max + 1)
          .map(&:destroy)
    end

    ##
    # @param [Faraday::Response] response
    # @param [GeoMonitor::Layer] layer
    # @param [Float] time
    def self.from_response(response, layer, time)
      create(
        res_time: time.to_f,
        res_code: response.status,
        submitted_query: response.env[:url].to_s,
        layer:,
        res_headers: response.headers,
        content_type: response.headers.try(:[], :content_type)
      )
    end
  end
end
