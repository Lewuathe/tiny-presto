# frozen_string_literal: true

require 'tiny-presto/version'
require 'tiny-presto/cluster'

require 'singleton'
require 'presto-client'

module TinyPresto
  # Singleton object representing a Presto cluster running in the local machine.
  class TinyPresto
    include Singleton

    attr_reader :cluster, :client

    def initialize
      @cluster = Cluster.new
      @cluster.run
      @client = Presto::Client.new(
        server: 'localhost:8080',
        catalog: 'memory',
        user: 'tiny-user',
        schema: 'default',
        # TODO: Remove after presto-client-ruby supports Trino
        http_headers: {
          'X-Trino-User' => 'tiny-user',
          'X-Trino-Catalog' => 'memory',
          'X-Trino-Schema' => 'default'
        })
      loop do
        @client.run('show schemas')
        break
      rescue StandardError => _
        # Waiting for the cluster is launched
        sleep(1)
      end
    end

    def stop
      @cluster.stop
    end
  end

  def self.print_record(record)
    ret = record.map do |v|
      if v.is_a? Numeric
        v.to_s
      else
        # Non numeric value is interpreted as string
        "'#{v}'"
      end
    end
    "(#{ret.join(',')})"
  end

  def self.prepare(table_name, table_data)
    # {'c1': [1, 2, 3], 'c2': ['a', 'b', 'c']}
    columns = table_data.keys
    records = []
    table_data.each do |_, rows|
      rows.each_with_index do |r, idx|
        if records[idx].nil?
          records << [r]
        else
          records[idx] << r
        end
      end
    end
    values_clause = []
    records.each do |record|
      values_clause << print_record(record)
    end
    query = "CREATE TABLE #{table_name} AS SELECT * FROM (values #{values_clause.join(',')}) t(#{columns.join(',')})"
    run_with_retry(query)
  end

  # Run the given SQL.
  #
  #   TinyPresto.run("show schemas")
  #
  def self.run(sql)
    presto = TinyPresto.instance
    _, rows = presto.client.run(sql)
    rows
  end

  # Run the given query with retrying in case of undeterministic error.
  #
  #   TinyPresto.run_with_retry("show schemas")
  #
  def self.run_with_retry(sql, max_retry = 3)
    max_retry.times do
      return run(sql)
    rescue Presto::Client::PrestoQueryError => e
      # Cluster may be in the initialization phase.
      raise unless e.message.match?(/^No nodes available to run query/)

      sleep(1000)
      next
    end
  end

  # Run the given SQL and verify the result.
  #
  #  TinyPresto.verify("show schemas", [["default"], ["information_schema"]])
  #  # => return true
  def self.verify(sql, expected_result)
    rows = run_with_retry(sql)
    rows == expected_result
  end

  # Make sure to stop the cluster.
  #
  #  TinyPresto.ensure_stop
  #
  def self.ensure_stop
    presto = TinyPresto.instance
    presto.stop
  end
end
