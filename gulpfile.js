'use strict';

const gulp = require('gulp');
const clean = require('gulp-clean');
const eslint = require('gulp-eslint');
const browserify = require('browserify');
const watchify = require('watchify');
const vinyl = require('vinyl-source-stream');
const babelify = require('babelify'); // transforms ES6 to ES5

const config = {
	paths: {
		js: './app/assets/javascripts/storefront/**/*.js',
		dist: './app/assets/javascripts/',
		mainJS: './app/assets/javascripts/storefront/App.js'
	}
};

gulp.task('apply-node-env', () => {
  process.env.NODE_ENV = process.env.NODE_ENV || 'production';
});

gulp.task('clean-scripts', () => {
  return gulp.src(config.paths.dist + 'application_bundle.js', {read: false})
    .pipe(clean());
});

gulp.task('js', ['apply-node-env', 'clean-scripts'], () => {
	browserify(config.paths.mainJS)
		.transform(babelify, {presets: ['es2015', 'react']})
		.bundle()
		.on('error', console.error.bind(console))
		.pipe(vinyl('application_bundle.js'))
		.pipe(gulp.dest(config.paths.dist));
});

gulp.task('lint', () => {
  return gulp.src(config.paths.js)
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failAfterError());
});

gulp.task('watch', ['apply-node-env'], () => {
  let b = browserify({
    entries:      [config.paths.mainJS],
    cache:        {},
    packageCache: {},
    plugin:       [watchify]
  });

  function bundle() {
    b.transform(babelify, {presets: ['es2015', 'react']})
      .bundle()
      .on('error', console.error.bind(console))
      .pipe(vinyl('application_bundle.js'))
      .pipe(gulp.dest(config.paths.dist));
  }

  b.on("update", bundle);
  b.on("log", function (msg) {
    console.log(msg);
  });
  bundle();
});

gulp.task('default', ['watch']);
