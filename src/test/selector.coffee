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

    partial: (æ) ->
        results = [
            '<div class="x"></div>'
            '<div class="x">fin</div>'
            '<circle class="x"/>'
        ]
        tpl = new Template schema:5, ->
            @$div class:'x', ->
                @add new Template schema:'svg', ->
                    @$svg ->
                        @$circle class:'x'
                    @on 'end', ->
                        æ.equals results.length, 0
                        æ.done()
            @$div class:'x', "fin"

        $(tpl).on '.x', (el) ->
            el.once('end', -> æ.equals @toString(), results.shift())

