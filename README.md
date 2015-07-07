# Highcharts::Export::Image

Allow to export highchart js graph as image

# Dependances

Phantomjs

# Public

Highcharts::Export::Image.chart_to_img(chart_js, outfile_path, options: {})
Highcharts::Export::Image.file_to_img(chart_file, outfile_path, options: {})

See Options availables


## Usage

Example:
```ruby
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
    end
```

# Options availables

(from http://www.highcharts.com/component/content/article/2-articles/news/52-serverside-generated-chart)

-type:	The type can be of jpg, png, pfd or svg. Ignored when outfile is defined. This is used when specifying the outfile has no usage. For example in servermode, when the output isn't a file but a 64bit string. When not running in servermode the file is stored in 'tmpdir'

-scale:	To set the zoomFactor of the page rendered by PhantomJs. For example, if the chart.width option in the chart configuration is set to 600 and the scale is set to 2, the output raster image will have a pixel width of 1200. So this is a convenient way of increasing the resolution without decreasing the font size and line widths in the chart. This is ignored if the -width parameter is set.

-width:	Set the exact pixel width of the exported image or pdf. This overrides the -scale parameter.

-constr:	The constructor name. Can be one of Chart or StockChart. This depends on whether you want to generate Highstock or basic Highcharts.

-callback:	Filename containing a callback JavaScript. The callback is a function which will be called in the constructor of Highcharts to be executed on chart load. All code of the callback must be enclosed by a function. Example of contents of the callback file:

    function(chart) {
        chart.renderer.arc(200, 150, 100, 50, -Math.PI, 0).attr({
            fill : '#FCFFC5',
            stroke : 'black',
            'stroke-width' : 1
         }).add();
    }


## Contributing

1. Fork it ( http://github.com/<my-github-username>/rails-mblox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request