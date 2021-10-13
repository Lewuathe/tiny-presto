# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TinyPresto do
  describe '#version' do
    it 'correct' do
      expect(TinyPresto::VERSION).to eq('0.0.7')
    end
  end
end
