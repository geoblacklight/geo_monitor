module GeoMonitor
  class LatLngPoint
    attr_accessor :lat, :lng
    def initialize(lat: 0, lng: 0)
      @lat = lat.to_f
      @lng = lng.to_f
    end

    ##
    # This needs better documentation, but projecting from EPSG:4326 to
    # EPSG:3857
    def to_3857
      d = Math::PI / 180
      max = 1 - 1E-15
      sin = [[Math.sin(lat * d), max].min, -max].max
      self.class.new(
        lng: ::GeoMonitor::Constants::R * lng * d,
        lat: ::GeoMonitor::Constants::R * Math.log((1 + sin) / (1 - sin)) / 2
      )
    end

    # Get the lat/lng for a specific tile at a zoom level
    # From http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Pseudo-code
    def self.from_number(xtile, ytile, zoom)
      n = 2.0**zoom
      lng = xtile / n * 360.0 - 180.0
      lat_rad = Math.atan(Math.sinh(Math::PI * (1 - 2 * ytile / n)))
      lat = 180.0 * (lat_rad / Math::PI)
      new(lat: lat, lng: lng)
    end
  end
end
