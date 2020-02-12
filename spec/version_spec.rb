# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TinyPresto do
  describe '#version' do
    it 'correct' do
      expect(TinyPresto::VERSION).to eq('0.0.5')
    end
  end
end
