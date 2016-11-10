const argv = require('yargs').argv;
const babelify = require('babelify'); // transforms ES6 to ES5
const browserify = require('browserify');
const chalk = require('chalk');
const clean = require('gulp-clean');
const config = require('../config').browserify;
const eslint = require('gulp-eslint');
const gulp = require('gulp');
const gutil = require('gulp-util');
const vinyl = require('vinyl-source-stream');
const watchify = require('watchify');

// Initializations
const _true = chalk.green('true');
const _false = chalk.red('false');
const prodBuild = argv.prod;
const isDevelopment = process.env.NODE_ENV !== 'production';

// Status Check
gutil.log('Is build prod?', prodBuild ? _true : _false);
gutil.log('Is this dev?', isDevelopment ? _true : _false);

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
		.on('error', (err) => gutil.log(chalk.red(err)))
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
  const b = browserify({
    entries:      [config.paths.mainJS],
    cache:        {},
    packageCache: {},
    plugin:       [watchify]
  });

  // var bundler = browserify({
  //       cache: {},
  //       packageCache: {},
  //       fullPaths: false,
  //       transform: config.settings.transform
  //   });

  function bundle() {
    const startTime = new Date().getTime();
    // if (prodBuild){
    //     return bundler.bundle()
    //         .on('error', crashProcess)
    //         .pipe(source(options.output))
    //         .pipe(buffer())
    //         .pipe(uglify())
    //         .pipe(gulp.dest(options.destination))
    //         .on('end', function () {
    //             const time = (new Date().getTime() - startTime) / 1000;
    //             gutil.log(options.output, 'took', `${time}s` );
    //         });
    // } else { // development build should not be minified and compressed
    //     return bundler.bundle()
    //         .on('error', function (err) {
    //             if (isDevelopment) {
    //                 beeper('*');
    //                 return console.log(chalk.bgBlack.red(err.message));
    //             }
    //             crashProcess(err);
    //         })
    //         .pipe(source(options.output))
    //         .pipe(gulp.dest(options.destination))
    //         .on('end', function () {
    //             const time = (new Date().getTime() - startTime) / 1000;
    //             gutil.log('Finished', `'${chalk.green(options.output)}'`, 'took', chalk.magenta(time, 's') );
    //         });
    // }

    b.transform(babelify, {presets: ['es2015', 'react']})
      .bundle()
      .on('error', (err) => gutil.log(chalk.red(err)))
      .pipe(vinyl('application_bundle.js'))
      .pipe(gulp.dest(config.paths.dist))
      .on('end', function () {
        const time = (new Date().getTime() - startTime) / 1000;
        gutil.log('Finished. Took', chalk.magenta(time, 's') );
      });
  }

  b.on("update", bundle);
  b.on("log", function (msg) {
    gutil.log(msg);
  });
  b.on('end', function () {
    const time = (new Date().getTime() - startTime) / 1000;
    gutil.log(options.output, 'took', `${time}s` );
  });


  bundle();
});

gulp.task('default', ['watch']);
