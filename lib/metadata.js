/*jshint esversion: 6 */

var osa = require('osa');
var osascript = require('osascript');
var fs = require('fs');
var path = require('path');

var artists = loadMetadata('artists');
var genres = loadMetadata('genres');

function ignoreCase(a, b) {
  a = a.replace(/^The /i, '');
  b = b.replace(/^The /i, '');
  return a.localeCompare(b, 'en', {'sensitivity': 'base'});
}

function resetMetadata(type) {
  if (type == 'artists') {
    artists = [];
  } else if (type == 'genres') {
    genres = [];
  }
}

function loadMetadata(type, callback) {
  var cacheFilePath = '/tmp/' + type + '.txt';

  fs.stat(cacheFilePath, function (error, stats) {
    if (error) {
      resetMetadata(type);
      updateMetadata(type, readMetadataFile(type, cacheFilePath, callback));
    } else {
      readMetadataFile(type, cacheFilePath,callback);
    }
  });
}

function readMetadataFile(type, filePath, callback) {
  fs.readFile(filePath, 'utf8', function (error, contents) {
      if (error) {
        resetMetadata(type);
        if (callback) callback(error);
      } else {
        var parsedMetadata = contents.toString().split('\n').sort(ignoreCase);

        if (type == 'artists') {
          artists = parsedMetadata;
        } else if (type == 'genres') {
          genres = parsedMetadata;
        }

        if (callback) callback(null, parsedMetadata);
      }
    });
}

function updateMetadata(type, callback) {
  var options = {
      type: 'AppleScript',
      args: [type]
    };

  osascript.file(path.join(__dirname, 'metadata.applescript'), options, function (error, data) {
      if (error) {
        console.log(error);
      } else {
        console.log(type + " metadata updated");
      }

      if (callback) callback();
    });
}

module.exports = {
  getArtists: function(callback) {
    if (!artists || artists.length == 0) {
      loadMetadata('artists', function (error, data) {
        if (error) {
          callback(error);
        } else {
          callback(null, data);
        }
      });
    } else {
      if (callback) callback(null, artists);
    }
  },

  getGenres: function(callback) {
    if (!genres || genres.length == 0) {
      loadMetadata('genres', function (error, data) {
        if (error) {
          callback(error);
        } else {
          callback(null, data);
        }
      });
    } else {
      if (callback) callback(null, genres);
    }
  },

  updateArtists: function(callback) {
    updateMetadata('artists');
    callback(null, true);
  },

  updateGenres: function(callback) {
    updateMetadata('genres');
    callback(null, true);
  }
};