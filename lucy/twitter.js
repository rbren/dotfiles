var HttpClient = require('https');

exports.getTweetsNearWhiteHouse = function(query, callback) {
  exports.api.search ({
    'query': query,
    'geocode': '38.898748,-77.037684,1mi',
  }, callback);
}
 

exports.api = {};

exports.api.search = function(inputs, callback) {
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
    'query': inputs['query'],
  }
  req.write(JSON.stringify(toSend) + '\n');
  req.end();
}

