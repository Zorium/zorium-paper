_ = require 'lodash'
z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'
NotchedOutline = require '../notched_outline'

if window?
  require './index.styl'

module.exports = class Select
  constructor: ({value} = {}) ->
    @stateSubscription = null
    value ?= new Rx.BehaviorSubject null
    @valueWrite = new Rx.ReplaySubject 1
    @valueRead = Rx.Observable.merge @valueWrite, value

    @$notchedOutline = new NotchedOutline()

    @state = z.state {
      isFocused: false
      isAtBottom: false
      error: null
      width: null
      value: @valueRead
    }

  afterMount: (@$$el) =>
    $$select = @$$el.querySelector '.zp-select > .input > select'
    unless $$select?
      throw new Error '$$select not found'

    $$labelWidth =
      @$$el.querySelector '.zp-select > .input > .label-width'
    unless $$labelWidth?
      throw new Error '$$labelWidth not found'

    $$labelWidthShrunk =
      @$$el.querySelector '.zp-select > .input > .label-width-shrunk'
    unless $$labelWidthShrunk?
      throw new Error '$$labelWidthShrunk not found'

    @stateSubscription = @state
      .distinctUntilChanged _.isEqual
      .subscribe ({isFocused, value, width}) =>
        requestAnimationFrame =>
          targetWidth = Math.max(
            $$select.getBoundingClientRect().width + 48
            $$labelWidth.getBoundingClientRect().width + 48
          )

          if targetWidth isnt width
            @state.set
              width: targetWidth

          if isFocused or value?
            @$notchedOutline.setNotchWidth \
              $$labelWidthShrunk.getBoundingClientRect().width
          else
            @$notchedOutline.setNotchWidth 0

  beforeUnmount: =>
    @stateSubscription?.unsubscribe()
    @$$el = null
    @state.set
      isFocused: false

  setError: (error) => @state.set {error}

  stream: => @valueRead

  render: ({
    color
    label
    helper
    isFilled
    isDisabled
    $icon
    name
    onblur
    onfocus
    tabindex
    options
  }) =>
    {value, error, isFocused, isAtBottom, width}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    isDisabled ?= false

    z '.zp-select',
      className: z.classKebab {
        hasValue: value?
        hasIcon: $icon?
        isFilled
        isFocused
        isDisabled
        isError: error?
        isAtBottom
      }
      style:
        width: if $icon?
          width + 36 + 'px'
        else
          width + 'px'
        '--color-base': colors["$#{color}500"]
      z '.input',
        tabindex: tabindex or 0
        onfocus: (e) =>
          $$options = e.currentTarget.querySelector('.options')
          unless $$options?
            throw new Error '.options not found'

          @state.set
            isFocused: true
            isAtBottom:
              $$options.getBoundingClientRect().bottom > window.innerHeight
          onfocus? e
        onblur: (e) =>
          @state.set
            isFocused: false

          # XXX: closing animation
          setTimeout =>
            @state.set
              isAtBottom: false
          , 200

          onblur? e
        onkeydown: (e) =>
          keys =
            40: 'down'
            38: 'up'
            13: 'enter'
          key = keys[e.keyCode]
          unless key?
            return

          e.preventDefault()
          if key is 'enter'
            e.currentTarget.blur()
            return
          {value} = @state.getValue()
          selectedIndex = _.findIndex options, {value}

          selectedIndex += switch key
            when 'down'
              1
            when 'up'
              -1
            else
              throw new Error "Unexpected key #{key}"

          if selectedIndex < 0
            selectedIndex = options.length + selectedIndex
          @valueWrite.next options[selectedIndex % options.length].value
        z 'select',
          disabled: if isDisabled then true
          name: name
          _.map options, ({value, label}) ->
            z 'option',
              value: value
              label
        z @$notchedOutline,
          isFocused: isFocused
          # TODO: darken on hover
          color: switch
            when isDisabled
              colors['$black26']
            when error?
              colors["$error"]
            when isFocused
              colors["$#{color}500"]
            else
              colors['$black54']
        z '.label', {
          style:
            color: if isFocused and not error? \
                   then colors["$#{color}500"]
        },
          label
        z '.label-width', label
        z '.label-width-shrunk', label
        if $icon?
          z '.icon',
            $icon
        z '.value',
          _.find(options, {value})?.label
        z '.triangle'
        z '.underlines',
          z '.static'
          z '.dynamic',
            style:
              background: switch
                when error?
                  colors["$error"]
                when isFocused
                  colors["$#{color}500"]
        z '.options',
          _.map options, (option) =>
            z '.option',
              className: z.classKebab
                isSelected: (option.value or null) is value
              onclick: (e) =>
                @valueWrite.next option.value
                e.currentTarget.parentElement.parentElement.blur()
              option.label
      z '.helper',
        error or helper
