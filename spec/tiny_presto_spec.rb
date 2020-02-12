# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TinyPresto do
  after(:all) do
    TinyPresto.ensure_stop
  end

  describe 'run query' do
    it 'correctly' do
      rows = TinyPresto.run('show schemas')
      expect(rows.size).to eq(2)
      expect(rows[0]).to eq(['default'])
      expect(rows[1]).to eq(['information_schema'])
    end

    it 'verify' do
      expected = [[1, 'a'], [2, 'b']]
      result = TinyPresto.verify("select * from (values (1, 'a'), (2, 'b')) t(c1, c2)", expected)
      expect(result).to eq(true)
    end
  end

  describe 'prepare' do
    it 'dataset correctly' do
      data = { 'c1': [1, 2, 3], 'c2': %w[a b c] }
      TinyPresto.prepare('new_table', data)
      expected = [[1, 'a'], [2, 'b'], [3, 'c']]
      rows = TinyPresto.run_with_retry('select * from new_table')
      expect(rows).to eq(expected)
    end
  end
end
