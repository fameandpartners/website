const argv = require('yargs').argv;
const babelify = require('babelify'); // transforms ES6 to ES5
const browserify = require('browserify');
const buffer = require('vinyl-buffer');
const chalk = require('chalk');
const clean = require('gulp-clean');
const eslint = require('gulp-eslint');
const gulp = require('gulp');
const gutil = require('gulp-util');
const source = require('vinyl-source-stream');
const uglify = require('gulp-uglify');
const watchify = require('watchify');
const lrload = require("livereactload");
const inquirer = require('inquirer');
const _ = require('lodash');

// Initializations
const config = require('../config').browserify;
const _true = chalk.green('true');
const _false = chalk.red('false');

const bundle = function(args) {
  const options = _.extend({}, args, argv);
  const isProd = options.prod; // Will be useful for separation from pipeline
  const isDevelopment = process.env.NODE_ENV !== 'production';
  const isWatch = options.watch;
  const isLiveReloadActive = !isProd && isWatch && options.livereload;

  // Status Check
  gutil.log('Is build using watchify?', isWatch ? _true : _false );
  gutil.log('Is LiveReload active', isLiveReloadActive ? _true : _false );
  gutil.log('Is build prod?', isProd ? _true : _false);
  gutil.log('Is this dev?', isDevelopment ? _true : _false);

  function generateEntries( bundleList ) {
    if (isLiveReloadActive) {
      gutil.log(new inquirer.Separator().line);

      if (_.has(options, 'lrbundle') && config.paths.mainJS[options.lrbundle]) {
        gutil.log('LIVE RELOADING: ', config.paths.mainJS[options.lrbundle]);
        return Promise.resolve([ config.paths.mainJS[options.lrbundle], ]);
      } else {
        return inquirer
          .prompt({
            type: 'list',
            name: 'bundle',
            message: 'Which bundle to use for LiveReload?',
            choices: bundleList,
          })
          .then(function(answer) {
            gutil.log(new inquirer.Separator().line);
            gutil.log('LIVE RELOADING: ', answer.bundle);
            return [answer.bundle,];
          });
      }
    } else {
      return Promise.resolve(bundleList);
    }
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

  function doBundle(bundler, filename, withuglify) {
    gutil.log( "Bundling " + filename );
    const startTime = new Date().getTime();

    if (isProd)
    {
      let toReturn = bundler.bundle()
          .on('error', crashProcess)
          .pipe(source(filename))
          .pipe(buffer());
      if( withuglify )
      {
        toReturn = toReturn.pipe(uglify())
      }
      return toReturn.pipe(gulp.dest(config.dest))
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
        .pipe(source(filename))
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
            .pipe(eslint({ fix: true, }))
            .pipe(eslint.format());

      doBundle(bundler);
    });
  }

  function createBundle(resolve) {
    return generateEntries(_.values(config.paths.mainJS))
      .then(entries => {
        const pluginList = isLiveReloadActive ? [ lrload, ] : [];
        const bundler = browserify({
          entries: entries,
          cache: {},
          plugin: pluginList,
          packageCache: {},
          transform: config.settings.transform,
        });

        isWatch && attachBundleUpdate(bundler);

        doBundle(bundler, 'application_bundle.js', true);
        resolve();
      });
  }

  return {
    create: () => new Promise(createBundle),
  };
};

gulp.task('clean-scripts', () => {
  return gulp.src(config.paths.dist + 'application_bundle.js', {read: false,})
    .pipe( gulp.src(config.paths.dist + 'shopping_pree_bundle.js', {read: false,}) )
    .pipe(clean());
});

gulp.task('browserify', () => {
  const BUNDLE = bundle();
  return BUNDLE.create();
});

gulp.task('watch', () => {
  const BUNDLE = bundle({ watch: true, });
  return BUNDLE.create();
});

gulp.task('default', ['watch',]);
