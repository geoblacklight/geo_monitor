require 'spec_helper'

describe GeoMonitor::LatLngPoint do
  subject do
    described_class.new(lat: 21.943045533438177, lng: -103.359375)
  end
  describe '#to_3857' do
    it { expect(subject.to_3857.lat).to eq(2504688.542848655) }
    it { expect(subject.to_3857.lng).to eq(-11505912.99371101) }
  end
end
