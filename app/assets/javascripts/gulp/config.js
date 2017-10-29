const baseDir = './app/assets/javascripts';
const gutil = require('gulp-util');
const envify = require('envify');

module.exports = {
  browserify: {
    settings: {
      transform: ['babelify', 'envify'],
    },
    paths: {
      js: './app/assets/javascripts/storefront/**/*.js',
      dist: './app/assets/javascripts/',
      mainJS: {
        CollectionFilterSortApp: './app/assets/javascripts/storefront/startup/CollectionFilterSortApp.jsx',
        GuestReturnsApp: './app/assets/javascripts/storefront/startup/GuestReturnsApp.jsx',
        ReturnsApp: './app/assets/javascripts/storefront/startup/ReturnsApp.jsx',

      },
      shoppingSpreeJS: {
        ShoppingSpreeApp: './app/assets/javascripts/shopping_spree/App.js',            
      },
    },
    src: `${baseDir}/*.jsx`,
    dest: baseDir,
    debug: gutil.env.type === 'dev',
  },
};
