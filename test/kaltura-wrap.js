var Client = require('./kaltura-swag.js');


exports.getnewestmedia = function(nameLike) {
  return Client. ({
    'orderBy': '+createdAt',
    'nameLike': nameLike,
  });
}
 

