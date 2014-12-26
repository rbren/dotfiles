var Util = require('util');
var FS = require('fs');
var KalturaConstants = require('./kaltura/KalturaTypes.js');
var Kaltura = require('./kaltura/KalturaClient.js');
var KalturaCreds = JSON.parse(FS.readFileSync('kaltura/creds.json'));

var Config = new Kaltura.KalturaConfiguration(1760921);
var KalturaClient = new Kaltura.KalturaClient(Config);

console.log('kalt:' + Util.inspect(Kaltura.objects.KalturaMediaEntryFilter, {depth: 1, colors: true}));

var Session = null;

exports.initialzed = false;
exports.init = function(callback) {
  KalturaClient.session.start(function(session) {
    console.log('started!');
    KalturaClient.setKs(session);
    Session = session;
    exports.initialized = true;
    callback();
  }, KalturaCreds.admin_secret, KalturaCreds.user_id, KalturaConstants.KalturaSessionType.ADMIN,
     KalturaCreds.partner_id, KalturaCreds.session_length);
}

exports.api.getMedia = function(filterOptions, callback) {
  if (!initialized) return initialize( function() {exports.api.getMedia(filterOptions, callback)} );
  var filter = new Kaltura.objects.KalturaMediaEntryFilter();
  for (var key in filterOptions) {
    filter[key] = filterOptions[key];
  }
  var pager = new Kaltura.objects.KalturaFilterPager();
  console.log('pager:' + Util.inspect(pager));
  KalturaClient.media.listAction(function(results) {
    console.log('results:' + JSON.stringify(results));
    callback(results);
  }, filter, pager);
}
