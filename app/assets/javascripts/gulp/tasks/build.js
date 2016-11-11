const gulp = require('gulp');

gulp.task('apply-node-env', () => {
  process.env.NODE_ENV = process.env.NODE_ENV || 'production';
});

gulp.task('build', ['apply-node-env', 'browserify']);
