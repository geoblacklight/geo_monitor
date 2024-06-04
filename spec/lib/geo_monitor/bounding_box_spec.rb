# frozen_string_literal: true

require 'spec_helper'

describe GeoMonitor::BoundingBox do
  subject(:box) do
    described_class.new(
      north: 4.234077,
      south: -1.478794,
      west: 29.572742,
      east: 35.000308
    )
  end

  describe '#to_s' do
    it 'w,s,e,n' do
      expect(box.to_s).to eq '29.572742,-1.478794,35.000308,4.234077'
    end
  end

  describe '#zoom_level' do
    it 'calculates the preferred zoom level' do
      expect(box.zoom_level).to eq 6
    end
  end

  describe '#tile_number' do
    it do
      expect(box.tile_number).to include(x: 37, y: 32)
    end
  end
end
