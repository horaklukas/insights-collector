'use strict';

require('./less/main.less');

var version = require('../package.json').version;
var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var options = {
  appVersion: version,
  webpages: window.WEBPAGES || []
}
var app = Elm.Main.embed(mountNode, options);

ElmLocalStoragePorts.subscribe(app)