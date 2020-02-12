# frozen_string_literal: true

require 'docker-api'

module TinyPresto
  # Represents a Presto cluster
  #
  class Cluster
    def initialize(tag = 'latest')
      @tag = tag
      @image_name = "prestosql/presto:#{@tag}"
    end

    # Launch Presto cluster running on Docker container
    def run
      # Ensure to pull the specified image
      Docker::Image.create('fromImage' => @image_name)
      @container = Docker::Container.create(
        'Image' => @image_name,
        'HostConfig' => {
          'PortBindings' => {
            '8080/tcp' => [
              {
                'HostPort' => '8080'
              }
            ]
          }
        }
      )
      @container.start
      @container
    end

    # Kill Presto cluster process
    def stop
      @container.stop
    end
  end
end
