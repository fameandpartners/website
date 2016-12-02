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
      mainJS: [
        './app/assets/javascripts/storefront/App.js',
        './app/assets/javascripts/storefront/startup/SlayItForwardApp.jsx',
        './app/assets/javascripts/storefront/startup/CollectionFilterSortApp.jsx'
      ]
    },
    src: baseDir + '/*.jsx',
    dest: baseDir,
    debug: gutil.env.type === 'dev'
  }
};
