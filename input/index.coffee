_ = require 'lodash'
z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'
NotchedOutline = require '../notched_outline'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({value} = {}) ->
    @stateSubscription = null
    value ?= new Rx.BehaviorSubject ''
    @valueWrite = new Rx.ReplaySubject 1
    @valueRead = Rx.Observable.merge value, @valueWrite

    @$notchedOutline = new NotchedOutline()

    @state = z.state {
      isFocused: false
      error: null
      value: @valueRead
    }

  afterMount: (@$$el) =>
    $$labelWidth = @$$el.querySelector '.zp-input > .input > .label-width'
    unless $$labelWidth?
      throw new Error '$$labelWidth not found'

    @stateSubscription = @state
      .distinctUntilChanged _.isEqual
      .subscribe ({isFocused, value}) =>
        requestAnimationFrame =>
          if isFocused or value? and value isnt ''
            @$notchedOutline.setNotchWidth \
              $$labelWidth.getBoundingClientRect().width
          else
            @$notchedOutline.setNotchWidth 0

  beforeUnmount: =>
    @stateSubscription?.unsubscribe()
    @$$el = null
    @state.set
      isFocused: false

  focus: =>
    if @$$el?
      $$input = @$$el.querySelector '.zp-input > .input > input'
      $$input.focus()

  setError: (error) => @state.set {error}
  setValue: (value) => @valueWrite.next value

  stream: => @valueRead

  render: ({
    color
    label
    helper
    isFilled
    isDisabled
    $icon
    type
    name
    autocapitalize
    autocomplete
    onblur
    onfocus
    onkeydown
    oninput
    tabindex
  }) =>
    {value, error, isFocused}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isDisabled ?= false
    autocapitalize ?= 'none'
    hasValue = value? and value isnt ''

    z '.zp-input',
      className: z.classKebab {
        hasValue
        hasIcon: $icon?
        isFilled
        isFocused
        isDisabled
        isError: error?
      }
      z '.input',
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
        if $icon?
          z '.icon',
            $icon
        z 'input',
          disabled: if isDisabled then true
          type: type
          autocapitalize: autocapitalize
          name: name
          autocomplete: autocomplete
          tabindex: tabindex
          value: value
          style:
            caretColor: unless error? then colors["$#{color}500"]
          oninput: (e) =>
            @valueWrite.next e.currentTarget.value
            oninput? e
          onfocus: (e) =>
            @state.set
              isFocused: true
            onfocus? e
          onblur: (e) =>
            @state.set
              isFocused: false
            onblur? e
          onkeydown: onkeydown
        z '.underlines',
          z '.static'
          z '.dynamic',
            style:
              background: switch
                when error?
                  colors["$error"]
                when isFocused
                  colors["$#{color}500"]
      z '.helper',
        error or helper
