{ EventEmitter } = require 'events'
parse = require 'slick/parser'

# TODO selector using asyncxml.Builder::register


class Selector extends EventEmitter
    constructor: (tpl) ->
        @selectors = []
        @listen(tpl) if tpl?
        @on('newListener', @onlistener)

    listen: (@template) ->
        @builder = @template.xml ? @template
        @builder._selectors = ({i, level:0} for s,i in @selectors)
        @builder.on('add', @onadd.bind(this))
        this

    onlistener: (event, listener) ->
        for sel in parse event
            sel.event =  event
            @builder?._selectors.push {i:@selectors.length, level:0}
            @selectors.push sel
            # cache operator regexps
            for s of sel when s.attributes?
                for a in s.attributes
                    esc = a.escapedValue
                    a.operatorRegExp = switch a.operator
                        when '^=' then RegExp(      "^#{esc}"       )
                        when '$=' then RegExp(       "#{esc}$"      )
                        when '~=' then RegExp("(^|\\s)#{esc}(\\s|$)")
                        when '|=' then RegExp(      "^#{esc}(-|$)"  )
                        else null
        this

    onadd: (parent, el) ->
        matched = {} # set
        el._selectors = []
        for sel in parent._selectors ? @builder._selectors
            selector = @selectors[sel.i]
            if sel.combinator isnt '>' # FIXME more plz
                el._selectors.push sel
            continue unless @match(el, selector[sel.level])
            if sel.level+1 < selector.length
                el._selectors.push {i:sel.i, level:sel.level+1}
            else if sel.level+1 is selector.length
                matched[selector.event] = yes
        for event, _ of matched
            @emit(event, el)
        this

    # eats objects like {combinator:…, [tag:…,] [id:…,] [classes:…,] …}
    match: (tag, sel) ->
        return no if tag is tag.builder
        # tag name
        if sel.tag?
            if sel.tag is '*'
                return no if tag.name < '@'
            else if sel.tag isnt tag.name
                return no
        # id
        return no if sel.id? and sel.id isnt tag.attr('id')
        # classes
        tagclass = tag.attr('class') ? ""
        return no for cls in sel.classList ? [] when tagclass.indexOf(cls) is -1
        # attributes
        for a in sel.attributes ? []
            unless a.operator
                return no if not tag.attr(a.name)
                continue
            return no if not (val = tag.attr(a.name))
            esc = a.escapedValue
            switch a.operator
                when '*=' then return no if val.indexOf(a.value) is -1
                when  '=' then return no if val isnt a.value
                when '^=','$=','~=','|='
                    return no unless a.operatorRegExp.test(val)
                else return no
        # pseudos
        # TODO
        # nothing to say against it anymore …
        return yes

# exports

module.exports = -> new Selector(arguments...)
module.exports.Selector = Selector

