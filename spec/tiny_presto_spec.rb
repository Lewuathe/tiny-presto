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
end
