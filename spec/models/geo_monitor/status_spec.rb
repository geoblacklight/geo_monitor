require 'spec_helper'

describe GeoMonitor::Status do
  let(:schema_json) { File.read('spec/fixtures/cz128vq0535.json') }
  let(:layer) { GeoMonitor::Layer.from_geoblacklight(schema_json) }
  let(:request) do
    GeoMonitor::Requests::WMS.new(
      url: layer.url, bbox: layer.bounding_box, layers: layer.layername
    )
  end
  before do
    stub_request(
      :get,
      %r{https:\/\/geowebservices.stanford.edu\/geoserver\/wms}
    ).to_return(status: 200, headers: { 'Content Type' => 'image/png' })
  end
  describe '#limit_by_layer' do
    it 'never will create more than the max allowed statuses per layer' do
      response = request.tile
      expect { 10.times { described_class.from_response(response, layer, 0.007) } }
        .to change { described_class.count }.by(5)
    end
  end
  describe '.from_response' do
    it 'creates a GeoMonitor::Status' do
      response = request.tile
      subject = described_class.from_response(response, layer, 0.007)
      expect(subject).to be_an described_class
      expect(subject.res_time).to eq 0.007
      expect(subject.res_code).to eq '200'
      expect(subject.submitted_query).to include('geowebservices.stanford.edu')
      expect(subject.res_headers).to include 'image/png'
    end
  end
end
