require "highcharts/export/image"
require 'pry'

describe Highcharts::Export::Image do
  before :all do
    @options_js = <<-eos
      {
          chart: {
        type: 'spline',
        width: 1000,
        height: 600
            },
              title: {
        text: 'Monthly Average Temperature'
            },
              subtitle: {
        text: 'Source: WorldClimate.com'
            },
              xAxis: {
        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
              yAxis: {
        title: {
            text: 'Temperature'
          },
                  labels: {
            formatter: function () {
          return this.value + '°';
            }
        }
          },
              tooltip: {
        crosshairs: true,
                  shared: true
            },
              plotOptions: {
        spline: {
            marker: {
          radius: 4,
                          lineColor: '#666666',
                          lineWidth: 1
              }
        }
          },
              series: [{
                  name: 'Tokyo',
          marker: {
                      symbol: 'square'
              },
          data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, {
              y: 26.5,
            marker: {
            symbol: 'url(http://www.highcharts.com/demo/gfx/sun.png)'
                }
          }, 23.3, 18.3, 13.9, 9.6]

          }, {
                  name: 'London',
          marker: {
                      symbol: 'diamond'
              },
          data: [{
              y: 3.9,
            marker: {
            symbol: 'url(http://www.highcharts.com/demo/gfx/snow.png)'
                }
          }, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
          }]
      }
    eos
  end

  it 'convert good chart' do
    Tempfile.open(['oufilefile', '.svg']) do |f|
      Highcharts::Export::Image.chart_to_img(@options_js, f.path)
      f.close
      f.size.should > 0
    end
  end

  it 'convert bad chart' do
    Tempfile.open(['oufilefile', '.svg']) do |f|
      begin
        Highcharts::Export::Image.chart_to_img("bad tex+_]\'dwt" + @options_js, f.path)
        "Should raise StandardError".should == "true"
      rescue StandardError
        f.close
        f.size.should == 0
      rescue
        "Should raise StandardError".should == "true"
      end
    end
  end

  it 'convert bad argument' do
    Tempfile.open(['oufilefile', '.svg']) do |f|
      begin
        Highcharts::Export::Image.chart_to_img(@options_js, f.path, :options => { :infile => "bad file" })
        "Should raise ArgumentError".should == "true"
      rescue ArgumentError
        f.close
        f.size.should == 0
      rescue Exception => e
        "Should raise ArgumentError".should == "true"
      end
    end
  end

  it 'test readme example' do
    Highcharts::Export::Image.configure do |config|
      config.default_options = { :type => :svg }
      config.phantomjs = "/usr/local/bin/phantomjs"
    end

    options_js = <<-eos
      {
          chart: {
        type: 'spline',
        width: 1000,
        height: 600
            },
              title: {
        text: 'Monthly Average Temperature'
            },
              subtitle: {
        text: 'Source: WorldClimate.com'
            },
              xAxis: {
        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
              yAxis: {
        title: {
            text: 'Temperature'
          },
                  labels: {
            formatter: function () {
          return this.value + '°';
            }
        }
          },
              tooltip: {
        crosshairs: true,
                  shared: true
            },
              plotOptions: {
        spline: {
            marker: {
          radius: 4,
                          lineColor: '#666666',
                          lineWidth: 1
              }
        }
          },
              series: [{
                  name: 'Tokyo',
          marker: {
                      symbol: 'square'
              },
          data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, {
              y: 26.5,
            marker: {
            symbol: 'url(http://www.highcharts.com/demo/gfx/sun.png)'
                }
          }, 23.3, 18.3, 13.9, 9.6]

          }, {
                  name: 'London',
          marker: {
                      symbol: 'diamond'
              },
          data: [{
              y: 3.9,
            marker: {
            symbol: 'url(http://www.highcharts.com/demo/gfx/snow.png)'
                }
          }, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
          }]
      }
    eos

    Tempfile.open(['oufilefile', '.svg']) do |f|
      Highcharts::Export::Image.chart_to_img(options_js, f.path)
      f.close
      f.size.should > 0
    end
  end
end