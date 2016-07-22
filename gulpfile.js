'use strict';

var gulp = require('gulp');
var clean = require('gulp-clean');
var browserify = require('browserify');
var vinyl = require('vinyl-source-stream');
var babelify = require('babelify'); // transforms ES6 to ES5

var config = {
	paths: {
		js: './app/assets/javascripts/storefront/**/*.js',
		dist: './app/assets/javascripts/',
		mainJS: './app/assets/javascripts/storefront/App.js'
	}
};

gulp.task('apply-node-env', function() {
  process.env.NODE_ENV = process.env.NODE_ENV || 'production';
});

gulp.task('clean-scripts', function () {
  return gulp.src(config.paths.dist + 'application_bundle.js', {read: false})
    .pipe(clean());
});

gulp.task('js', ['apply-node-env', 'clean-scripts'], function() {
	browserify(config.paths.mainJS)
		.transform(babelify, {presets: ['es2015', 'react']})
		.bundle()
		.on('error', console.error.bind(console))
		.pipe(vinyl('application_bundle.js'))
		.pipe(gulp.dest(config.paths.dist));
});

gulp.task('watch', function() {
  gulp.watch(config.paths.js, ['apply-node-env', 'js']);
});

gulp.task('default', ['apply-node-env', 'js', 'watch']);
