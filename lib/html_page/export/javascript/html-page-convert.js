var system = require('system');
var args = system.args;

var html_content = null
var output = null
var options = {
  "width": null,
  "height": null,
  "format": "png",
  "quality": null,
  "wait_timeout": 4242,
  "paper_size": null,
  "zoom": 1
}

function help() {
  return ("usage: phantomjs html-page-convert.js html_content output [-zoom=INT] [-width=INT] [-height=INT] [-quality=INT] [-format=pdf|png|jpeg|gmp|ppm|gif] [-wait_timeout=INT] [-paper_size=JSON]");
}

args.forEach(function(arg, i) {
  if (i == 0) {
    // do nothing
  } else if (i == 1) {
    html_content = arg
  } else if (i == 2) {
    output = arg
  } else {
    if (arg.search(/--(.*)/) != -1) {
      options[arg.substring(2)] = true
    } else if (arg.search(/-(.*)=(.*)/) != -1) {
      options[arg.split("=")[0].substring(1)] = arg.split("=")[1]
    } else {
      console.log(help());
      phantom.exit();
    }
  }
});

function waitFor(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3000,
      start = new Date().getTime(),
      condition = false,
      interval = setInterval(function() {
          if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
            condition = (typeof(testFx) === "string" ? eval(testFx) : testFx());
          } else {
              if(!condition) {
                console.log("error: wait_for timeout");
                phantom.exit(1);
              } else {
                typeof(onReady) === "string" ? eval(onReady) : onReady();
                clearInterval(interval);
              }
          }
      }, 250);
};

output_checker = new RegExp('\.' + options["format"], 'i');
if (output.search(output_checker) == -1) {
  console.log("error: format and output does not match (should be ." + options["format"] + ")")
  phantom.exit(1);
}

var webPage = require('webpage');
var page = webPage.create();
var zoom = Number(options["zoom"]);
var width = options["width"];
var height = options["height"];

page.zoomFactor = zoom;

if (width || height) {
  page.viewportSize = { width: width * zoom, "height": height * zoom };
}

if (options["paper_size"]) {
  page.paperSize = JSON.parse(options["paper_size"]);
}

page.content = html_content

waitFor(function() {
   return page.evaluate(function() {
      var images = document.images;

      for(var i = 0; i < images.length; i++) {
        if (images[i].complete == false) {
          return false;
        }
      }

      return true;
   });
}, function() {
  if (page.render(output, { "format": options["format"], "quality": options["format"] })) {
    console.log("success")
    phantom.exit(0);
  } else {
    console.log("error: render");
    phantom.exit(1);
  }
}, options["wait_timeout"]);
