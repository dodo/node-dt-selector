{ Template } = require 'dynamictemplate'
$ = require '../dt-selector'

example = ->
    new Template schema:5, ->
        @$html ->
            @$head ->
                @$title "beep"
            @$body ->
                @$div class:'a', "¡¡¡"
                @$div class:'b', ->
                    @$span "tacos"
                    @$span "y"
                    @$span "burritos"
                @$div class:'a', "!!!"

module.exports =


    simple: (æ) ->
        tpl = do example

        $(tpl).on '.b span', (el) ->
            el.once('end', -> æ.equals @toString(), results.shift())

        tpl.on 'end', ->
            æ.equals results.length, 0
            æ.done()

        results = [
            "<span>tacos</span>"
            "<span>y</span>"
            "<span>burritos</span>"
        ]
