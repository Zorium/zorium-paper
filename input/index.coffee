z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({value} = {}) ->
    value ?= new Rx.BehaviorSubject null
    @valueWrite = new Rx.ReplaySubject 1
    @valueRead = Rx.Observable.merge @valueWrite, value

    @state = z.state {
      isFocused: false
      wasFocused: false
      error: null
      value: @valueRead
    }

  afterMount: (@$$el) => null
  beforeUnmount: =>
    @$$el = null
    @state.set
      isFocused: false
      wasFocused: false

  focus: =>
    if @$$el?
      $$input = @$$el.querySelector '.zp-input > .input'
      $$input.focus()

  wasFocused: => @state.getValue().wasFocused

  setError: (error) => @state.set {error}
  setValue: (value) => @valueWrite.next value

  stream: => @valueRead

  render: ({
    color
    label
    type
    isFloating
    isDisabled
    autocapitalize
    name
    autocomplete
    onblur
    onkeydown
    oninput
    tabindex
    isDark
    min
    dir
    isBoxed
  }) =>
    {value, error, isFocused}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false
    autocapitalize ?= 'none'

    z '.zp-input',
      className: z.classKebab {
        isFloating
        hasValue: value? and value isnt ''
        isFocused
        isDisabled
        isError: error?
        isDark
        isBoxed
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors["$#{color}500"]
      },
        label
      z 'input.input',
        disabled: if isDisabled then true
        type: type
        autocapitalize: autocapitalize
        name: name
        autocomplete: autocomplete
        tabindex: tabindex
        value: value
        min: min
        dir: dir
        style:
          caretColor: unless error? then colors["$#{color}500"]
        oninput: (e) =>
          @valueWrite.next e.currentTarget.value
          oninput? e
        onfocus: =>
          @state.set
            isFocused: true
            wasFocused: true
        onblur: (e) =>
          @state.set
            isFocused: false
          onblur? e
        onkeydown: onkeydown
      z '.underline-wrapper',
        z '.underline',
          style:
            backgroundColor: if isFocused and not error? \
                             then colors["$#{color}500"]
      if error?
        z '.error', error
