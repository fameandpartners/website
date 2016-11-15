const argv = require('yargs').argv;
const babelify = require('babelify'); // transforms ES6 to ES5
const browserify = require('browserify');
const buffer = require('vinyl-buffer');
const chalk = require('chalk');
const clean = require('gulp-clean');
const config = require('../config').browserify;
const eslint = require('gulp-eslint');
const gulp = require('gulp');
const gulpIf = require('gulp-if');
const gutil = require('gulp-util');
const source = require('vinyl-source-stream');
const uglify = require('gulp-uglify');
const watchify = require('watchify');

// Initializations
const _true = chalk.green('true');
const _false = chalk.red('false');
const isProd = argv.prod; // Will be useful for separation from pipeline
const isDevelopment = process.env.NODE_ENV !== 'production';
const isWatch = argv.watch;

// Status Check
gutil.log('Is build using watchify?', isWatch ? _true : _false );
gutil.log('Is build prod?', isProd ? _true : _false);
gutil.log('Is this dev?', isDevelopment ? _true : _false);

/**
 * Checks if a file's eslint flag is fixed
 * @param  {Object} file
 * @return {Boolean}
 */
function isFixed(file) {
    return file.eslint !== null && file.eslint.fixed;
}

/**
 * Exits from bundle build
 * @param  {Object} err
 */
function crashProcess (err) {
    gutil.log(err);
    gutil.log(chalk.red(err.message));
    gutil.log(err.stack);
    process.exit(1);
}

function bundle(bundler) {
    const startTime = new Date().getTime();

    if (isProd){
      return bundler.bundle()
          .on('error', crashProcess)
          .pipe(source('application_bundle.js'))
          .pipe(buffer())
          .pipe(uglify())
          .pipe(gulp.dest(config.dest))
          .on('end', function () {
              const time = (new Date().getTime() - startTime) / 1000;
              gutil.log(`Finished. Took: ${time}s`);
          });
    } else { // development build should not be minified and compressed
      return bundler.bundle()
        .on('error', function (err) {
          if (isDevelopment) { return gutil.log(chalk.red(err.message)); }
          crashProcess(err);
        })
        .pipe(source('application_bundle.js'))
        .pipe(gulp.dest(config.dest))
        .on('end', function () {
          const time = (new Date().getTime() - startTime) / 1000;
          gutil.log('Finished. Took:', chalk.magenta(time, 's') );
        });
    }
}

function attachBundleUpdate(bundler){
  bundler = watchify(bundler);
  bundler.on('update', function (updatedFile) {
    const lint = gulp.src(updatedFile)
      .pipe(eslint({
        fix: true
      }))
      .pipe(eslint.format())
      .pipe(gulpIf(
        isFixed,
        gulp.dest(config.paths.dist)
      ));

    bundle(bundler);
  });
}

function createBundle() {
  const bundler = browserify({
    entries: [config.paths.mainJS],
    cache: {},
    packageCache: {},
    transform: config.settings.transform
  });
  if (isWatch) { attachBundleUpdate(bundler); }
  return bundle(bundler);
}


gulp.task('clean-scripts', () => {
  return gulp.src(config.paths.dist + 'application_bundle.js', {read: false})
    .pipe(clean());
});

// gulp.task('js', ['apply-node-env', 'clean-scripts'], () => {
// 	browserify(config.paths.mainJS)
// 		.transform(babelify, {presets: ['es2015', 'react']})
// 		.bundle()
// 		.on('error', (err) => gutil.log(chalk.red(err)))
// 		.pipe(vinyl('application_bundle.js'))
// 		.pipe(gulp.dest(config.paths.dist));
// });

// gulp.task('lint', () => {
//   return gulp.src(config.paths.js)
//     .pipe(eslint())
//     .pipe(eslint.format())
//     .pipe(eslint.failAfterError());
// });

gulp.task('browserify', () => {
  const startTime = new Date().getTime();
  const bundle = createBundle();
});

gulp.task('default', ['watch']);
