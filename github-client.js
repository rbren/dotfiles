var HttpClient = require('https');

exports.getReposForUser = function(username, callback) {
  var requestOptions = {
    host: 'api.github.com',
    port: 443,
    path: '/users/:username/repos',
    headers: {"User-Agent":"request"},
    method: 'get',
  }
  requestOptions.path = requestOptions.path.replace(':username', username);

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
  req.end();
}

exports.createRepoForUser = function(auth_token, name, description, private, auto_init, callback) {
  var requestOptions = {
    host: 'api.github.com',
    port: 443,
    path: '/user/repos',
    headers: {"User-Agent":"request",
              "Authorization":"token :auth_token"},
    method: 'post',
  }
  requestOptions.headers['Authorization'] = requestOptions.headers['Authorization'].replace(':auth_token', auth_token);

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
    'name': name,
    'description': description,
    'private': private,
    'auto_init': auto_init,
  }
  req.write(JSON.stringify(toSend) + '\n');
  req.end();
}
