require 'spec_helper'

RSpec.describe TinyPresto do
  describe '#version' do
    it 'correct' do
      expect(TinyPresto::VERSION).to eq('0.0.1')
    end
  end
end
