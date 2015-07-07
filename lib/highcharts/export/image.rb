require "highcharts/export/image/version"
require "highcharts/export/image/configuration"

module Highcharts
  module Export
    module Image
      attr_accessor :config

      # Handle basic errors
      #
      def self.handle_errors(result)
        if result["Error: Insuficient or wrong parameters for rendering"] || result["Error: cannot find file"]
          throw ArgumentError.new(result)
        elsif result["ERROR: the options variable was not available or couldn't be parsed, does the infile contain an syntax error?"]
          throw StandardError.new(result)
        end
      end

      # Convert chart_string (contain js chart) into image
      #
      def self.chart_to_img(chart_js, outfile_path, options: {})
        Tempfile.open(['chart', '.js']) do |f|
          f.write(chart_js)
          f.flush

          return self.file_to_img(f, outfile_path, :options => options)
        end
      end

      # Convert chart_file (contain js chart) into image
      #
      def self.file_to_img(chart_file, outfile_path, options: {})
        config ||= Highcharts::Export::Image.config
        options = config.default_options.merge(options)
        options_line = options.inject([]) { |options_array, (option, value)| options_array << (value ? "-#{option} #{value}" : "--#{option}" ); options_array }.join(' ')

        cmd = "#{config.phantomjs} #{config.highchart_convert} -infile '#{chart_file.path}' -outfile '#{outfile_path}' #{options_line}"
        result = `#{cmd}`

        self.handle_errors(result)

        return outfile_path
      end
    end
  end
end
