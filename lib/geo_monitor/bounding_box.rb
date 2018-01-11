module GeoMonitor
  ##
  # Bounding Box
  class BoundingBox
    attr_reader :north, :south, :east, :west

    def initialize(north:, south:, east:, west:)
      @north = north.to_f
      @south = south.to_f
      @east = east.to_f
      @west = west.to_f
    end

    def to_s
      "#{west},#{south},#{east},#{north}"
    end

    ##
    # Calculates the tilebounds for a tile within the existing bounds.
    def tile_bounds
      tile = tile_number
      zoom = zoom_level
      sw = ::GeoMonitor::LatLngPoint.from_number(tile[:x], tile[:y], zoom).to_3857
      ne = ::GeoMonitor::LatLngPoint.from_number(tile[:x] + 1, tile[:y] - 1, zoom).to_3857
      self.class.new(
        north: ne.lat,
        east: ne.lng,
        south: sw.lat,
        west: sw.lng
      )
    end

    ##
    # Calculates the "zoom level" that can best view the bounds.
    # http://wiki.openstreetmap.org/wiki/Zoom_levels
    def zoom_level
      lat_diff = north - south
      lng_diff = east - west
      max_diff = [lat_diff, lng_diff].max

      if max_diff < ::GeoMonitor::DEGREES_IN_CIRCLE / 2**20
        zoom = 21
      else
        zoom = -1 * ((Math.log(max_diff) / Math.log(2)) - (Math.log(::GeoMonitor::DEGREES_IN_CIRCLE) / Math.log(2)))
        zoom = 1 if zoom < 1
      end
      zoom.ceil
    end

    ##
    # See: http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Lon..2Flat._to_tile_numbers_2
    def tile_number
      lat_rad = south / 180 * Math::PI
      n = 2.0**zoom_level
      x = ((west + 180.0) / ::GeoMonitor::DEGREES_IN_CIRCLE * n).to_i
      y = ((1.0 - Math.log(Math.tan(lat_rad) + (1 / Math.cos(lat_rad))) / Math::PI) / 2.0 * n)
      y = if y.infinite?.nil?
            y.to_i
          else
            x
          end
      { x: x, y: y }
    end
  end
end
