z = require 'zorium'
Rx = require 'rxjs/Rx'

colors = require '../colors.json'

if window?
  require './index.styl'

readWriteStreams = (stream, onChange, defaultValue) ->
  if not stream?.subscribe?
    stream = new Rx.BehaviorSubject stream or defaultValue

  if not stream?.next? and not onChange?
    throw new Error 'Must use change handler if stream not writeable'
  else if not onChange?
    onChange = (value) -> stream.next value

  [stream, onChange]

module.exports = class Input
  constructor: ({
    @value
    @error
    onValue
    onError
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
  } = {}) ->
    [@value, onValue] = readWriteStreams @value, onValue, ''
    [@error, onError] = readWriteStreams @error, onError, null

    color ?= 'blue'
    label ?= ''
    type ?= 'text'
    isFloating ?= false
    isDisabled ?= false
    autocapitalize ?= 'none'

    @state = z.state {
      @value
      @error
      onValue
      onError
      color
      label
      type
      isFloating
      isDisabled
      autocapitalize
      isFocused: false
      wasFocused: false
      name
      autocomplete
      onblur
      onkeydown
      oninput
      tabindex
      isDark
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

  render: =>
    {
      value
      error
      onValue
      onError
      color
      label
      type
      isFloating
      isDisabled
      autocapitalize
      isFocused
      name
      autocomplete
      onblur
      onkeydown
      oninput
      tabindex
      isDark
    } = @state.getValue()

    z '.zp-input',
      className: z.classKebab {
        isFloating
        hasValue: value? and value isnt ''
        isFocused
        isDisabled
        isError: error?
        isDark
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
        oninput: (e) ->
          onValue e.currentTarget.value
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
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors["$#{color}500"]
      if error?
        z '.error', error
