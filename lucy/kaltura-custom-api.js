var Client = require('./kaltura-raw-api.js');


exports.getVideosAboutWhiteHouse = function() {
  return Client.({
    'nameLike': 'White House',
    'orderBy': '+createdAt',
  });
}
 

