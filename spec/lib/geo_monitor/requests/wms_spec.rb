require 'spec_helper'

describe GeoMonitor::Requests::WMS do
  let(:url) { 'https://geowebservices.stanford.edu/geoserver/wms' }
  let(:bbox) do
    GeoMonitor::BoundingBox.new(
      north: 4.234077,
      south: -1.478794,
      west: 29.572742,
      east: 35.000308
    )
  end
  let(:layers) { 'druid:cz128vq0535' }
  subject { described_class.new(bbox: bbox, url: url, layers: layers) }

  describe '#tile' do
    context 'when everything is fine' do
      it 'requests a wms tile' do
        stub = stub_request(
          :get,
          'https://geowebservices.stanford.edu/geoserver/wms?BBOX=3130860.6785'\
            '60819,0.0,3757032.814272983,626172.1357121639&CRS=EPSG:900913&FOR'\
            'MAT=image/png&HEIGHT=256&LAYERS=druid:cz128vq0535&REQUEST=GetMap&'\
            'SERVICE=WMS&SRS=EPSG:3857&STYLES=&TILED=true&VERSION=1.1.1&WIDTH='\
            '256'
        ).to_return(headers: { 'Content-Type' => 'image/png' })
        expect(subject.tile).to be_an Faraday::Response
        expect(stub).to have_been_requested
      end
    end
    context 'when bad things happen' do
      it 'returns a GeoMonitor::FailedResponse' do
        stub = stub_request(
          :get,
          'https://geowebservices.stanford.edu/geoserver/wms?BBOX=3130860.6785'\
            '60819,0.0,3757032.814272983,626172.1357121639&CRS=EPSG:900913&FOR'\
            'MAT=image/png&HEIGHT=256&LAYERS=druid:cz128vq0535&REQUEST=GetMap&'\
            'SERVICE=WMS&SRS=EPSG:3857&STYLES=&TILED=true&VERSION=1.1.1&WIDTH='\
            '256'
        ).to_raise(Faraday::ConnectionFailed)
        expect(subject.tile).to be_an GeoMonitor::FailedResponse
        expect(stub).to have_been_requested
      end
      it 'returns a GeoMonitor::FailedResponse' do
        stub = stub_request(
          :get,
          'https://geowebservices.stanford.edu/geoserver/wms?BBOX=3130860.6785'\
            '60819,0.0,3757032.814272983,626172.1357121639&CRS=EPSG:900913&FOR'\
            'MAT=image/png&HEIGHT=256&LAYERS=druid:cz128vq0535&REQUEST=GetMap&'\
            'SERVICE=WMS&SRS=EPSG:3857&STYLES=&TILED=true&VERSION=1.1.1&WIDTH='\
            '256'
        ).to_raise(Faraday::TimeoutError)
        expect(subject.tile).to be_an GeoMonitor::FailedResponse
        expect(stub).to have_been_requested
      end
    end
  end
end
