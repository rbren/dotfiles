var Client = require('./nyt-swag.js');

Client.API('http://api.nytimes.com');

exports.sortByOldest = function(query, apiKey) {
  return Client.articleSearch ({
    'sort': 'oldest',
    'q': query,
    'apiKey': apiKey,
  });
}
 

