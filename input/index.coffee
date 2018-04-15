z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

module.exports = class Input
  constructor: ({value} = {}) ->
    value ?= new Rx.BehaviorSubject ''
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
      $$input = @$$el.querySelector '.zp-input > .input > input'
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
    isBoxed
    $prefix
  }) =>
    {value, error, isFocused}  = @state.getValue()
    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false
    autocapitalize ?= 'none'
    hasValue = value? and value isnt ''

    if $prefix? and not isFloating
      throw new Error '$prefix not supported for non-floating inputs'

    z '.zp-input',
      className: z.classKebab {
        isFloating
        hasValue
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
      z '.input',
        z '.prefix',
          className: z.classKebab {
            isVisible: (isFocused or hasValue) and $prefix?
          }
          $prefix
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
