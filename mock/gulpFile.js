var gulp = require('gulp');
var clean = require('gulp-clean');
var sass = require('gulp-sass')
var bourbon = require('node-bourbon');
var path = require('path');
var root = path.resolve(__dirname);
var src = path.resolve(__dirname, 'assets/scss/style.scss');
var dist = path.resolve(__dirname, '../web');

gulp.task('clean', function() {
  return gulp.src([dist], {
    read: false
  })
      .pipe(clean())
});
gulp.task('sass', function() {
  return gulp.src(src)
      .pipe(sass({
        includePaths: bourbon.includePaths
      }))
      .pipe(gulp.dest(dist))
});
