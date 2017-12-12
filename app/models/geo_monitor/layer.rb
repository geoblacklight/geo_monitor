module GeoMonitor
  class Layer < ApplicationRecord

    ##
    # @param [String] schema_json
    def self.from_geoblacklight(schema_json)
      schema = JSON.parse(schema_json)
      references = JSON.parse(schema['dct_references_s'])
      find_or_create_by(slug: schema['layer_slug_s']) do |layer|
        layer.checktype = 'WMS'
        layer.layername = schema['layer_id_s']
        layer.bbox = schema['solr_geom']
        layer.url = references['http://www.opengis.net/def/serviceType/ogc/wms']
        layer.active = true
      end
    end

    def bounding_box
      w, e, n, s = bbox.delete('ENVELOPE(').delete(')').delete(' ').split(',')
      GeoMonitor::BoundingBox.new(north: n, south: s, east: e, west: w)
    end
  end
end
