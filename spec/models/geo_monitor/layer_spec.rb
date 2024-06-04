# frozen_string_literal: true

require 'spec_helper'

describe GeoMonitor::Layer do
  subject(:layer) { described_class.from_geoblacklight(schema_json) }

  let(:schema_json) { File.read('spec/fixtures/cz128vq0535.json') }

  describe '.from_geoblacklight' do
    context 'with a WMS layer' do
      it 'creates an instance with expected fields' do
        expect(layer.checktype).to eq 'WMS'
        expect(layer.slug).to eq 'stanford-cz128vq0535'
        expect(layer.layername).to eq 'druid:cz128vq0535'
        expect(layer.bbox)
          .to eq 'ENVELOPE(29.572742, 35.000308, 4.234077, -1.478794)'
        expect(layer.active).to eq true
        expect(layer.institution).to eq 'Stanford'
        expect(layer.rights).to eq 'Public'
        expect(layer.url).to eq 'https://geowebservices.stanford.edu/geoserver/wms'
      end
    end

    context 'with an IIIF layer' do
      let(:schema_json) { File.read('spec/fixtures/image.json') }

      it 'creates an instance with expected fields' do
        expect(layer.checktype).to eq 'IIIF'
        expect(layer.slug).to eq 'princeton-jd472z992'
        expect(layer.layername).to eq 'jd472z992'
        expect(layer.bbox)
          .to eq 'ENVELOPE(-73.727775, -66.8850751, 47.459686, 40.950943)'
        expect(layer.active).to eq true
        expect(layer.institution).to eq 'Princeton'
        expect(layer.rights).to eq 'Public'
        expect(layer.url).to eq 'https://libimages.princeton.edu/loris/pulmap/jd/47/2z/99/2/00000001.jp2/info.json'
      end
    end
  end

  describe '#bounding_box' do
    it 'returns an instance of GeoMonitor::BoundingBox' do
      expect(layer.bounding_box).to be_an GeoMonitor::BoundingBox
    end

    it 'parses the CQL Envelope syntax correctly' do
      expect(layer.bounding_box.north).to eq 4.234077
      expect(layer.bounding_box.south).to eq(-1.478794)
      expect(layer.bounding_box.east).to eq 35.000308
      expect(layer.bounding_box.west).to eq 29.572742
    end
  end

  describe '#check' do
    before do
      stub_request(
        :get,
        %r{https://geowebservices.stanford.edu/geoserver/wms}
      ).to_return(status: 200, headers: {})
    end

    it 'creates a GeoMonitor::Status' do
      expect(layer.check).to be_an GeoMonitor::Status
    end

    it 'sends through correct arguments' do
      allow(GeoMonitor::Status).to receive(:from_response)
      layer.check
      expect(GeoMonitor::Status).to have_received(:from_response).with(
        kind_of(Faraday::Response),
        kind_of(described_class),
        kind_of(Float)
      )
    end
  end

  describe '#availability_score' do
    before do
      4.times { GeoMonitor::Status.create(layer:, res_code: '200', content_type: 'image/png') }
      GeoMonitor::Status.create(layer:, res_code: '404')
    end

    it 'calculates the availability score' do
      expect(layer.availability_score).to eq 0.8
    end
  end
end
