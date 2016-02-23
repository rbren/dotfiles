var Client = require('./kaltura-raw-api.js');


exports.getVideosAboutWhiteHouse = function(callback) {
  return Client.getMedia({
    'nameLike': 'White House',
    'orderBy': '+createdAt',
  }, callback);
}
 

