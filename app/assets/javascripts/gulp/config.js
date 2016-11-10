var dest = './public/assets-v2';
var src = './assets';
var gutil = require('gulp-util');
var path = require('path');


module.exports = {
  browserify: {
    settings: {
      transform: ['babelify']
    },
    paths: {
      js: './app/assets/javascripts/storefront/**/*.js',
      dist: './app/assets/javascripts/',
      mainJS: './app/assets/javascripts/storefront/App.js'
    },
    debug: gutil.env.type === 'dev'
  }
};
