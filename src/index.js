'use strict';

require('./less/main.less');

// force copying to dist
require('./index.html');

var version = require('../package.json').version;
var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var options = {
  apiUrl: API_URL,
  appVersion: version
}
var app = Elm.Main.embed(mountNode, options);