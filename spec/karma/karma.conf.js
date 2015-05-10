// Karma configuration
// copied from https://raw.githubusercontent.com/manuisfunny/ucommentator/master/test/karma.conf.js

module.exports = function(config) {
    config.set({

        // base path that will be used to resolve all patterns (eg. files, exclude)
        basePath: '.',


        // frameworks to use
        // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
        frameworks: ['jasmine'],


        // list of files / patterns to load in the browser
        files: [
            '../../vendor/assets/components/angular/angular.js',
            '../../vendor/assets/components/angular-mocks/angular-mocks.js',
            '../../vendor/assets/components/toastr/toastr.js',
            '../../vendor/assets/components/angular-local-storage/dist/angular-local-storage.js',
            '../../vendor/assets/components/angular-jwt/dist/angular-jwt.js',
            '../../vendor/assets/components/angular-bootstrap/ui-bootstrap.js',
            '../../vendor/assets/components/angular-ui-router/release/angular-ui-router.js',
            '../../vendor/assets/components/angular-spinner/angular-spinner.js',
            '../../vendor/assets/components/restangular/dist/restangular.js',
            '../../vendor/assets/components/lodash/lodash.js',
            '../../vendor/assets/components/spin.js/spin.js',
            '../../vendor/assets/components/karma-read-json/karma-read-json.js',
            // FIXME I don't undertand why I needed to add app.js, before the **/*.js was working,
            // but when I actually did the ls **/*.js, it didn't show up
            '../../app/assets/javascripts/app.js',
            '../../app/assets/javascripts/states.js',
            '../../app/assets/javascripts/**/*.js',
            './unit/**/*.js',
            {
                pattern: './fixtures/*.json',
                watched: true,
                served: true,
                included: false
            }
        ],

        plugins: [
            'karma-jasmine',
            'karma-phantomjs-launcher'
        ],


        // list of files to exclude
        exclude: [
        ],


        // preprocess matching files before serving them to the browser
        // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
        preprocessors: {
        },


        // test results reporter to use
        // possible values: 'dots', 'progress'
        // available reporters: https://npmjs.org/browse/keyword/karma-reporter
        reporters: ['progress'],


        // web server port
        port: 9876,


        // enable / disable colors in the output (reporters and logs)
        colors: true,


        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,


        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: true,


        // start these browsers
        // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
        browsers: ['PhantomJS'],


        // Continuous Integration mode
        // if true, Karma captures browsers, runs the tests and exits
        singleRun: false
    });
};