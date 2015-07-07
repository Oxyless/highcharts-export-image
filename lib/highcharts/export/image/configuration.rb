module Highcharts
  module Export
    module Image
      class << self
        attr_accessor :configuration

        def reset_config
          @config = Configuration.new
        end

        def config
          @config ||= Configuration.new
        end

        def configure
          yield self.config
        end
      end

      class Configuration
        attr_accessor :phantomjs, :default_options

        def highchart_convert
          @highchart_convert || File.join(Gem::Specification.find_by_name("highcharts-export-image").gem_dir, '/lib/highcharts.com/exporting-server/phantomjs/highcharts-convert.js')
        end

        def phantomjs
          @phantomjs || "/usr/local/bin/phantomjs"
        end

        def default_options
          @default_options || {}
        end
      end
    end
  end
end