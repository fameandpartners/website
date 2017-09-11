const baseDir = './app/assets/javascripts';
const gutil = require('gulp-util');
const envify = require('envify');

module.exports = {
  browserify: {
    settings: {
      transform: ['babelify', 'envify']
    },
    paths: {
      js: './app/assets/javascripts/storefront/**/*.js',
      dist: './app/assets/javascripts/',
      mainJS: {
        // 'App': './app/assets/javascripts/storefront/App.js',
        'SlayItForwardApp': './app/assets/javascripts/storefront/startup/SlayItForwardApp.jsx',
        'CollectionFilterSortApp': './app/assets/javascripts/storefront/startup/CollectionFilterSortApp.jsx',
        'GuestReturnsApp': './app/assets/javascripts/storefront/startup/GuestReturnsApp.jsx',
        'ReturnsApp': './app/assets/javascripts/storefront/startup/ReturnsApp.jsx',
      },
    },
    src: baseDir + '/*.jsx',
    dest: baseDir,
    debug: gutil.env.type === 'dev',
  },
};
