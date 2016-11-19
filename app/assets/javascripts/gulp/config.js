const baseDir = './app/assets/javascripts';
const gutil = require('gulp-util');

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
    src: baseDir + '/*.jsx',
    dest: baseDir,
    debug: gutil.env.type === 'dev'
  }
};
