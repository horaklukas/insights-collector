var fs = require('fs');
var colors = require('colors');
var FtpDeploy = require('ftp-deploy');
var ftpDeploy = new FtpDeploy();
var auth = JSON.parse(fs.readFileSync('.ftpauth', 'utf8'));
var credentials = auth.endora; // use server id to extract credentials

var config = {
    username: credentials.username,
    password: credentials.password,
    host: "srv8.endora.cz",
    port: 21,
    localRoot: __dirname + "/dist",
    remoteRoot: "/bacisovi.tode.cz/web/apps/insights-collector",
    exclude: []
}

ftpDeploy.deploy(config, function(err) {
    if (err) console.log(err.red)
    else console.log('Deployed!'.green);
});

ftpDeploy.on('uploading', function(data) {
    console.log('Deploying', data.filename);
});

ftpDeploy.on('uploaded', function(data) {
    var transferred = data.transferredFileCount + '/' + data.totalFileCount;
    console.log(('Completed ' + transferred + ' files').green);
});

ftpDeploy.on('error', function (data) {
    console.log(data.err.red);
});