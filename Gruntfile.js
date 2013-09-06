module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-notify');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-compass');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    compass : {
        dev: {
        options: {
            outputStyle : 'compressed',
            sassDir: 'app/scss',
            cssDir: 'app/css'
        }
        }
    },
    watch: {
        scss : {
        files: ['app/scss/**.scss'],
        tasks: ['compass:dev']
        }
    }
    });

    grunt.registerTask('default', [
    'compass:dev',
    'watch'
    ]);

    grunt.registerTask('staging', [
    'compass:dev'
    ]);

};
