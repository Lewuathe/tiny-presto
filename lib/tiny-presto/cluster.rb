require 'docker-api'

module TinyPresto
  class Cluster
    def initialize(url, tag = 'latest')
      @url = url
      @tag = tag
      @image_name = "prestosql/presto:#{@tag}"
    end

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

    def stop
      @container.stop
    end
  end
end
