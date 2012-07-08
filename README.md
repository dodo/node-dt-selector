# [Δt Selector Engine](https://github.com/dodo/node-dt-selector/)

This is a selector engine for [Δt](http://dodo.github.com/node-dynamictemplate/).


## Installation

```bash
$ npm install dt-selector
```


## Usage

```javascript
var $ = require('dt-selector');

var example = new Template({schema:5}, function() {
    this.$html(function() {
        this.$head(function() {
            this.$title("beep");
        });
        this.$body(function() {
            this.$div({class:'a'}, "¡¡¡");
            this.$div({class:'b'}, function() {
                this.$span("tacos");
                this.$span("y");
                this.$span("burritos");
            });
            this.$div({class:'a'}, "!!!");
        });
    });
});

$(example).on('.b span', function (el) {
    el.once('end', function () {
        console.log(this.toString());
    });
});
/* → stdout:
<span>tacos</span>
<span>y</span>
<span>burritos</span>
*/
```

## api

Same like nodejs' `EventEmitter`, instead that the given event name gets processed by a [CSS selector](http://www.w3.org/TR/CSS2/selector.html) [parser](https://github.com/kamicane/slick).
Every time a new tag is created in the xml tree, the matching event will be emitted with the tag as argument.

Since [Templates](), [Builder](http://dodo.github.com/node-asyncxml/#api/builder-opts) and [Tags](http://dodo.github.com/node-asyncxml/#api/tag-name-attrs-children-opts) have all the same [event api](http://dodo.github.com/node-asyncxml/#events) for new tags, it doesn't matter if you let the selector listen on the template or on a tag.


[![Build Status](https://secure.travis-ci.org/dodo/node-dt-selector.png)](http://travis-ci.org/dodo/node-dt-selector)
