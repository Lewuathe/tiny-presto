# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TinyPresto::Cluster do
  describe 'cluster' do
    before(:all) do
      @cluster = TinyPresto::Cluster.new
      @container = @cluster.run
      @client = Trino::Client.new(
        server: 'localhost:8080',
        catalog: 'memory',
        user: 'tiny-user',
        schema: 'default',
        # TODO: Remove after presto-client-ruby supports Trino
        http_headers: {
          'X-Trino-User' => 'tiny-user',
          'X-Trino-Catalog' => 'memory'
        })
      loop do
        @client.run('show schemas')
        break
      rescue StandardError => exception
        puts "Waiting for cluster ready... #{exception}"
        sleep(3)
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
      @client.run("create table default.ctas1 as select * from (values (1, 'a'), (2, 'b')) t(c1, c2)")
      columns, rows = @client.run('select * from default.ctas1')
      expect(columns.map(&:name)).to match_array(%w[c1 c2])
    end
  end
end
