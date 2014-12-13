var HttpClient = require('https');

exports.getReposForUser = function(username, callback) {
  var requestOptions = {
    host: 'api.twitter.com',
    port: 443,
    path: '/1.1/search/tweets.json',
    headers: {},
    method: 'get',
  }

  var req = HttpClient.request(requestOptions, function(res) {
    res.setEncoding('utf8');
    var data = '';
    res.on('error', function(err) {
      callback(err);
      callback = null;
    });
    res.on('data', function(dataIn) { data += dataIn; });
    res.on('end', function() {
      if (callback) {
        data = JSON.parse(data);
        callback(null, data);
      }
    })
  });
  var toSend = {
    'username': username,
  }
  req.write(JSON.stringify(toSend) + '\n');
  req.end();
}
