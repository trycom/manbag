
/**
 * Module dependencies.
 */

var express = require('express'),
  path = require('path'),
  config = require('./config/config'),
  fs = require('fs')
  //api = require('./api');

var app = module.exports = express();

// Configuration stuff
app.configure(function(){
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
});

var port;

console.log(config.ManbagAppPath);

// var api = require('./api');
// app.use('/api',api);
 
var serveStaticFiles = function(mode,app) {
  if (mode == "development") {

    // app.use(function(req,res,next){
    //   if (req.host == "localhost") {
    //     res.redirect("http://brandid.dev.com:3000"+req.url);
      
    //   }      else next()
    // });


    app.use(express.compress());  

    app.use('/',express.static(config.ManbagAppPath));  
    port = 3000;
    //app.use('/male',express.static(config.ManbagAppPath));
  } else if (mode == "production") {

    // Redirect to www.manb.ag
    app.use(function(req,res,next){
      if (req.host == "manb.ag") {
        res.redirect(301,"http://www.manb.ag"+req.url);
      } 
      else next();
    });

    port = 3000;
    var oneYear = 31557600000;

    app.use(express.compress());
    app.use('/',express.static(config.ManbagAppPath, {maxAge:oneYear}));  
//    app.use(express.static(config.ManbagAppPath,{maxAge:oneYear}));  
    //app.use('/male',express.static(config.ManbagAppPath),{maxAge:oneYear});
  }
}

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  serveStaticFiles('development',app);
});

app.configure('production', function(){
  app.use(express.errorHandler());
  serveStaticFiles('production',app);
});

// Mount api!

//app.use('/api',api);


// Start server


app.listen(port, function(){
  console.log("Express Brandid Assbreaking server listening on port %d in %s mode", this.address().port, app.settings.env);
});


process.on('uncaughtException', function (exception) {
   console.log('Uncaught exception');
   console.log(exception);
});