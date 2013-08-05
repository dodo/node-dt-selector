path = require 'path'
{ run, compileScript, minifyScript, exec, notify } = require 'muffin'

task 'compile', 'compile coffeescript → javascript', (options) ->
    run
        options:options
        after:options.after
        files:[
            "./src/**/*.coffee"
        ]
        map:
            'src/test/(.+).coffee': (m) ->
                compileScript m[0], path.join("test" ,"#{m[1]}.js"), options
            'src/(.+).coffee': (m) ->
                compileScript m[0], path.join("lib" ,"#{m[1]}.js"), options

task 'bundle', 'build a browser bundle', (options) ->
    run
        options:options
        files:[
            "./lib/*.js"
        ]
        map:
            'lib/(selector).js': (m) ->
                entry = path.join(__dirname, m[0])
                filename = "dt-#{m[1]}.browser.js"
                [child, promise] = exec "./node_modules/.bin/browserify #{entry} -o #{filename}"
                promise.then ->
                    notify m[0], "successful browserify!"
                    minifyScript filename, options

task 'build', 'compile && bundle', (options) ->
    timeout = 0
    options.after = ->
        clearTimeout(timeout) if timeout
        timeout = setTimeout( ->
            invoke 'bundle', options
        , 250)
    invoke 'compile'