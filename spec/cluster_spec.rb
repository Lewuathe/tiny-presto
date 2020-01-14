require 'spec_helper'

RSpec.describe TinyPresto::Cluster do
  describe 'cluster' do
    before(:all) do
      @cluster = TinyPresto::Cluster.new('localhost')
      @container = @cluster.run
      @client = Presto::Client.new(server: 'localhost:8080', catalog: 'memory', user: 'tiny-user', schema: 'default')
      loop do
        begin
          @client.run('show schemas')
          break
        rescue StandardError => exception
          puts 'Waiting for cluster ready...'
          sleep(3)
        end
      end
      puts 'Cluster is ready'
    end

    after(:all) do
      @cluster.stop
    end

    it 'correct container' do
      expect(@container).to be_truthy
    end

    it 'run read query' do
      columns, rows = @client.run('show schemas')
      expect(rows.length).to be(2)
    end

    it 'run CTAS query' do
      @client.run("create table ctas1 as select * from (values (1, 'a'), (2, 'b')) t(c1, c2)")
      columns, rows = @client.run('select * from ctas1')
      expect(columns.map(&:name)).to match_array(%w[c1 c2])
    end
  end
end
