'use strict';

var jsonServer = require('json-server');
var server = jsonServer.create(),
  router;

server.use(jsonServer.defaults());

router = jsonServer.router('db.json');
server.use(router);

console.log('listening at 4000');
server.listen(4000)
