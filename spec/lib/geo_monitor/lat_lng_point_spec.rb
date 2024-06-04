# frozen_string_literal: true

require 'spec_helper'

describe GeoMonitor::LatLngPoint do
  subject(:point) do
    described_class.new(lat: 21.943045533438177, lng: -103.359375)
  end

  describe '#to_3857' do
    it { expect(point.to_3857.lat).to eq(2_504_688.542848655) }
    it { expect(point.to_3857.lng).to eq(-11_505_912.99371101) }
  end
end
