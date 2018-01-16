module GeoMonitor
  module Requests
    ##
    # Crafts a WMS request
    class WMS
      attr_reader :bbox, :url, :layers

      def initialize(bbox:, url:, layers:)
        @bbox = bbox
        @url = url
        @layers = layers
      end

      ##
      # Parameters used for the WMS request.
      def request_params
        {
          'SERVICE' => 'WMS',
          'VERSION' => '1.1.1',
          'REQUEST' => 'GetMap',
          'LAYERS' => layers,
          'STYLES' => '',
          'CRS' => 'EPSG:900913',
          'SRS' => 'EPSG:3857',
          'BBOX' => bbox.tile_bounds.to_s,
          'WIDTH' => '256',
          'HEIGHT' => '256',
          'FORMAT' => 'image/png',
          'TILED' => true
        }
      end

      ##
      # Request the tile.
      def tile
        unless url.present?
          return ::GeoMonitor::FailedResponse.new(
            { url: url }, 'No URL provided', {}
          )
        end
        conn = Faraday.new(url: url)
        begin
          conn.get do |request|
            request.params = request_params
            request.options.timeout = 10
            request.options.open_timeout = 10
          end
        rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
          ::GeoMonitor::FailedResponse.new(
            { url: conn.url_prefix.to_s },
            e.class,
            nil
          )
        end
      end
    end
  end
end
