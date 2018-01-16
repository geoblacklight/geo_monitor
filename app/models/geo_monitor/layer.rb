module GeoMonitor
  class Layer < ApplicationRecord
    has_many :statuses

    ##
    # @param [String] schema_json
    def self.from_geoblacklight(schema_json)
      schema = JSON.parse(schema_json)
      references = JSON.parse(schema['dct_references_s'] || '{}')
      find_or_create_by(slug: schema['layer_slug_s']) do |layer|
        layer.checktype = 
          if references['http://www.opengis.net/def/serviceType/ogc/wms']
            'WMS'
          elsif references['http://iiif.io/api/image']
            'IIIF'
          end
        layer.institution = schema['dct_provenance_s']
        layer.rights = schema['dc_rights_s']
        layer.layername = schema['layer_id_s']
        layer.bbox = schema['solr_geom']
        layer.url = references['http://www.opengis.net/def/serviceType/ogc/wms'] || references['http://iiif.io/api/image']
        layer.active = true
      end
    end

    def bounding_box
      w, e, n, s = bbox.delete('ENVELOPE(').delete(')').delete(' ').split(',')
      ::GeoMonitor::BoundingBox.new(north: n, south: s, east: e, west: w)
    end

    def check
      response = nil
      time = Benchmark.measure do
        response = ::GeoMonitor::Requests::WMS.new(
          bbox: bounding_box, url: url, layers: layername
        ).tile
      end
      ::GeoMonitor::Status.from_response(response, self, time.real.to_f)
    end

    def availability_score
      statuses.where(res_code: '200', content_type: 'image/png').count.to_f / statuses.count
    end
  end
end
